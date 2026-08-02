import os
import json
import urllib.request
import zipfile
import argparse
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Any, Set
from PIL import Image

try:
    from tqdm import tqdm
except ImportError:
    print("tqdm is not installed. Please install it using `pip install tqdm`")
    exit(1)

# Task Categories Configuration
TASK_CATEGORIES = {
    1: ['chair', 'bench', 'suitcase', 'dining table'],
    2: ['couch', 'chair', 'bench', 'bed'],
    3: ['vase', 'bottle', 'bowl', 'cup', 'potted plant'],
    4: ['fork', 'spoon', 'knife', 'oven'],
    5: ['bottle', 'cup', 'bowl', 'potted plant'],
    6: ['spoon', 'fork', 'knife', 'cup'],
    7: ['umbrella', 'knife'],
    8: ['bottle', 'wine glass', 'knife', 'scissors'],
    9: ['scissors', 'knife', 'book', 'handbag'],
    10: ['wine glass', 'cup', 'bottle'],
    11: ['spoon', 'bowl', 'cup', 'bottle'],
    12: ['knife', 'spoon', 'fork', 'sandwich'],
    13: ['bottle', 'bowl', 'fire hydrant'],
    14: ['tennis racket', 'baseball bat'],
}

PREFERRED_CATEGORIES = {
    1: ['chair', 'bench', 'suitcase'],
    2: ['couch', 'chair', 'bench'],
    3: ['vase'],
    4: ['fork', 'spoon'],
    5: ['bottle', 'cup', 'bowl'],
    6: ['spoon', 'fork'],
    7: ['umbrella'],
    8: ['bottle', 'knife'],
    9: ['scissors', 'knife'],
    10: ['wine glass'],
    11: ['spoon'],
    12: ['knife'],
    13: ['fire hydrant', 'bottle'],
    14: ['tennis racket', 'baseball bat'],
}

TASK_DESCRIPTIONS = [
    'step on something to reach the top of a shelf',
    'sit comfortably',
    'place flowers in a container',
    'get potatoes out of fire',
    'water a plant',
    'get a lemon out of tea',
    'dig a hole',
    'open a bottle of beer',
    'open a parcel',
    'serve wine in a glass',
    'pour sugar',
    'smear butter on bread',
    'extinguish a fire',
    'pound a carpet',
]

def download_with_progress(url: str, dest_path: str, desc: str):
    """Download a file with a tqdm progress bar."""
    if os.path.exists(dest_path):
        return

    class TqdmUpTo(tqdm):
        def update_to(self, b=1, bsize=1, tsize=None):
            if tsize is not None:
                self.total = tsize
            self.update(b * bsize - self.n)

    with TqdmUpTo(unit='B', unit_scale=True, unit_divisor=1024, miniters=1, desc=desc) as t:
        urllib.request.urlretrieve(url, filename=dest_path, reporthook=t.update_to)

def download_coco_annotations(data_dir: Path) -> Path:
    """Download and extract COCO train2014 annotations if missing."""
    coco_dir = data_dir / 'coco'
    anno_dir = coco_dir / 'annotations'
    anno_dir.mkdir(parents=True, exist_ok=True)
    json_path = anno_dir / 'instances_train2014.json'
    
    if json_path.exists():
        print(f"Found COCO annotations at {json_path}")
        return json_path

    url = 'http://images.cocodataset.org/annotations/annotations_trainval2014.zip'
    zip_path = coco_dir / 'annotations_trainval2014.zip'
    
    print("Downloading COCO 2014 annotations...")
    download_with_progress(url, str(zip_path), "COCO Annotations")
    
    print(f"Extracting to {coco_dir}...")
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(coco_dir)
        
    # Clean up zip
    if zip_path.exists():
        zip_path.unlink()
        
    return json_path

def load_existing_task_data(task_id: int, data_dir: Path) -> Set[int]:
    """Load existing image IDs for a specific task."""
    anno_path = data_dir / 'coco-tasks-dataset' / 'annotations' / f'task_{task_id}_train.json'
    if not anno_path.exists():
        return set()
    
    with open(anno_path, 'r') as f:
        data = json.load(f)
        return {img['id'] for img in data.get('images', [])}

def get_category_name_to_id(coco_data: dict) -> dict:
    return {cat['name']: cat['id'] for cat in coco_data['categories']}

def mine_candidates(args, data_dir: Path, coco_data: dict):
    """Mine candidate images for each task from COCO."""
    candidates = []
    manifest_tasks = {}
    
    cat_name_to_id = get_category_name_to_id(coco_data)
    cat_id_to_name = {v: k for k, v in cat_name_to_id.items()}
    
    # Map image_id to its annotations
    img_id_to_annos = {}
    for ann in coco_data['annotations']:
        img_id_to_annos.setdefault(ann['image_id'], []).append(ann)
    
    # Map image_id to image info
    img_id_to_info = {img['id']: img for img in coco_data['images']}

    tasks_to_process = [args.task] if args.task else range(1, 15)
    
    crawled_dir = data_dir / 'crawled_candidates'
    crawled_dir.mkdir(parents=True, exist_ok=True)
    
    candidate_counter = 1
    
    for task_id in tasks_to_process:
        print(f"\nProcessing Task {task_id}: {TASK_DESCRIPTIONS[task_id-1]}")
        existing_img_ids = load_existing_task_data(task_id, data_dir)
        current_count = len(existing_img_ids)
        print(f"  Current train images: {current_count}")
        
        needed = args.target_count - current_count
        if needed <= 0:
            print("  Target count already reached or exceeded. Skipping.")
            manifest_tasks[str(task_id)] = {"current_count": current_count, "candidates": 0, "target": args.target_count}
            continue
            
        allowed_cat_names = TASK_CATEGORIES[task_id]
        allowed_cat_ids = {cat_name_to_id[name] for name in allowed_cat_names if name in cat_name_to_id}
        
        task_candidates = []
        task_dir = crawled_dir / f'task{task_id}'
        task_dir.mkdir(parents=True, exist_ok=True)
        
        # Iterate over all COCO images
        for img_info in coco_data['images']:
            img_id = img_info['id']
            if img_id in existing_img_ids:
                continue
                
            annos = img_id_to_annos.get(img_id, [])
            relevant_annos = [a for a in annos if a['category_id'] in allowed_cat_ids and not a.get('iscrowd', 0)]
            
            if not relevant_annos:
                continue
                
            # Collect unique relevant category names
            relevant_cat_names = list({cat_id_to_name[a['category_id']] for a in relevant_annos})
            
            cand_id = f"candidate_{candidate_counter:04d}"
            candidate_counter += 1
            
            img_path = task_dir / f"COCO_train2014_{img_id:012d}.jpg"
            
            # Format candidate info
            task_candidates.append({
                "id": cand_id,
                "task_id": task_id,
                "task_description": TASK_DESCRIPTIONS[task_id-1],
                "image_id": img_id,
                "image_path": str(img_path.relative_to(data_dir.parent) if data_dir.parent != data_dir else img_path),
                "coco_categories": relevant_cat_names,
                "coco_annotations": [{"bbox": a['bbox'], "category": cat_id_to_name[a['category_id']], "area": a['area']} for a in relevant_annos],
                "status": "pending",
                "verdict": None
            })
            
            if len(task_candidates) >= args.max_per_task:
                break
                
        print(f"  Found {len(task_candidates)} candidates.")
        
        # Download images if not dry run
        if not args.dry_run:
            print(f"  Downloading candidate images for Task {task_id}...")
            for cand in tqdm(task_candidates, desc=f"Task {task_id} Images"):
                url = f"http://images.cocodataset.org/train2014/COCO_train2014_{cand['image_id']:012d}.jpg"
                dest = data_dir.parent / cand['image_path'] if not Path(cand['image_path']).is_absolute() else Path(cand['image_path'])
                try:
                    download_with_progress(url, str(dest), f"Img {cand['image_id']}")
                except Exception as e:
                    print(f"  Failed to download {url}: {e}")
                    
        candidates.extend(task_candidates)
        manifest_tasks[str(task_id)] = {
            "current_count": current_count,
            "candidates": len(task_candidates),
            "target": args.target_count
        }
        
    manifest = {
        "created": datetime.now().isoformat(),
        "total_candidates": len(candidates),
        "tasks": manifest_tasks,
        "candidates": candidates
    }
    
    if not args.dry_run:
        manifest_path = crawled_dir / 'manifest.json'
        with open(manifest_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        print(f"\nManifest saved to {manifest_path}")
    else:
        print("\nDry run completed. No files downloaded or saved.")


def integrate_candidates(data_dir: Path):
    """Integrate verified candidates into the COCO-Tasks dataset."""
    manifest_path = data_dir / 'crawled_candidates' / 'manifest.json'
    if not manifest_path.exists():
        print(f"Manifest not found at {manifest_path}. Have you mined candidates yet?")
        return
        
    with open(manifest_path, 'r') as f:
        manifest = json.load(f)
        
    accepted = [c for c in manifest.get('candidates', []) if c.get('verdict') == 'ACCEPTED']
    if not accepted:
        print("No ACCEPTED candidates found in manifest.")
        return
        
    print(f"Found {len(accepted)} ACCEPTED candidates to integrate.")
    
    task_groups = {}
    for cand in accepted:
        task_groups.setdefault(cand['task_id'], []).append(cand)
        
    for task_id, cands in task_groups.items():
        print(f"\nIntegrating {len(cands)} images for Task {task_id}...")
        
        # Load existing annotation file
        anno_path = data_dir / 'coco-tasks-dataset' / 'annotations' / f'task_{task_id}_train.json'
        if not anno_path.exists():
            print(f"  Annotation file {anno_path} not found, skipping task {task_id}.")
            continue
            
        with open(anno_path, 'r') as f:
            task_data = json.load(f)
            
        # Get next annotation ID
        next_anno_id = 1
        if task_data.get('annotations'):
            next_anno_id = max(a['id'] for a in task_data['annotations']) + 1
            
        # Setup directories
        img_dir = data_dir / 'images' / f'task{task_id}' / 'train'
        img_640_dir = data_dir / 'images_640' / f'task{task_id}' / 'train'
        img_dir.mkdir(parents=True, exist_ok=True)
        img_640_dir.mkdir(parents=True, exist_ok=True)
        
        pref_cats = PREFERRED_CATEGORIES[task_id]
        
        for cand in tqdm(cands, desc=f"Task {task_id}"):
            src_path = data_dir.parent / cand['image_path'] if not Path(cand['image_path']).is_absolute() else Path(cand['image_path'])
            if not src_path.exists():
                print(f"  Missing source image: {src_path}")
                continue
                
            file_name = src_path.name
            dest_path = img_dir / file_name
            dest_640_path = img_640_dir / file_name
            
            # Copy and resize
            try:
                with Image.open(src_path) as img:
                    img.save(dest_path)
                    img_resized = img.resize((640, 640), Image.Resampling.LANCZOS)
                    img_resized.save(dest_640_path)
            except Exception as e:
                print(f"  Error processing image {src_path}: {e}")
                continue
                
            # Add image to annotations
            with Image.open(dest_path) as img:
                w, h = img.size
                
            task_data['images'].append({
                "id": cand['image_id'],
                "file_name": file_name,
                "width": w,
                "height": h
            })
            
            # Map categories to task specific categories if needed.
            # Assuming task_data['categories'] already has the right mapping, we find the ID by name.
            # In COCO-Tasks, the categories are usually 1..N. Let's find the ID for the category name.
            cat_name_to_task_id = {c['name']: c['id'] for c in task_data.get('categories', [])}
            
            # Add annotations
            for ann in cand['coco_annotations']:
                cat_name = ann['category']
                if cat_name not in cat_name_to_task_id:
                    # Category not in this task's categories, skip or add? Usually we skip irrelevant ones.
                    continue
                    
                pref = 1 if cat_name in pref_cats else 0
                
                task_data['annotations'].append({
                    "id": next_anno_id,
                    "image_id": cand['image_id'],
                    "category_id": cat_name_to_task_id[cat_name],
                    "bbox": ann['bbox'],
                    "area": ann['area'],
                    "iscrowd": 0,
                    "preference": pref
                })
                next_anno_id += 1
                
        # Save updated annotations
        with open(anno_path, 'w') as f:
            json.dump(task_data, f, indent=2)
            
        print(f"  Task {task_id} integration complete. Added {len(cands)} images.")


def main():
    parser = argparse.ArgumentParser(description="Crawl COCO dataset for COCO-Tasks augmentation.")
    parser.add_argument('--dry-run', action='store_true', help="Show what would be downloaded without downloading")
    parser.add_argument('--task', type=int, choices=range(1, 15), help="Only process specific task (1-14)")
    parser.add_argument('--max-per-task', type=int, default=200, help="Max candidates per task (default: 200)")
    parser.add_argument('--target-count', type=int, default=350, help="Target train count per task (default: 350)")
    parser.add_argument('--download-only', action='store_true', help="Download annotations + images, skip integration")
    parser.add_argument('--integrate', action='store_true', help="Integrate verified candidates into dataset")
    parser.add_argument('--data-dir', type=str, default='./data', help="Data directory (default: ./data)")
    
    args = parser.parse_args()
    
    data_dir = Path(args.data_dir).resolve()
    data_dir.mkdir(parents=True, exist_ok=True)
    
    if args.integrate:
        integrate_candidates(data_dir)
        return
        
    # Download annotations if needed
    if not args.dry_run:
        coco_anno_path = download_coco_annotations(data_dir)
    else:
        coco_anno_path = data_dir / 'coco' / 'annotations' / 'instances_train2014.json'
        
    if not coco_anno_path.exists():
        print(f"Error: Annotations not found at {coco_anno_path}. Cannot proceed in dry-run mode without them.")
        return
        
    print(f"Loading COCO annotations from {coco_anno_path}...")
    with open(coco_anno_path, 'r') as f:
        coco_data = json.load(f)
        
    mine_candidates(args, data_dir, coco_data)

if __name__ == '__main__':
    main()
