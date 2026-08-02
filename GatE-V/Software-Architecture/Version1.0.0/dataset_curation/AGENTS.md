# GatE-V Dataset Curation — Agent Guide

**Project**: GatE-V DVCon India 2026 (Team 166 — Byte Silicon)  
**Purpose**: Expand the COCO-Tasks dataset by mining COCO 2014, verifying image quality, and integrating accepted images.

---

## 1. Your Mission

You are curating training data for a **task-driven object detector**. The model detects objects relevant to 14 everyday tasks (e.g., "dig a hole" → detect a shovel). You will:

1. **Run the crawling script** to download COCO annotations and mine candidate images
2. **Visually verify** each candidate image for task relevance and quality
3. **Run the integration step** to add accepted images to the training dataset

---

## 2. The 14 Tasks

| Task ID | Description | Preferred Objects | Current Train Count | Priority |
|---------|-------------|-------------------|--------------------:|----------|
| 1 | Step on something to reach the top of a shelf | chair, bench, suitcase | ~248 | Medium |
| 2 | Sit comfortably | couch, chair, bench | ~252 | Medium |
| 3 | Place flowers in a container | **vase** | ~176 | 🔴 HIGH |
| 4 | Get potatoes out of fire | fork, spoon | ~208 | Medium |
| 5 | Water a plant | bottle, cup, bowl | ~192 | 🔴 HIGH |
| 6 | Get a lemon out of tea | spoon, fork | ~224 | Medium |
| 7 | Dig a hole | umbrella | ~220 | Medium |
| 8 | Open a bottle of beer | bottle, knife | ~180 | 🔴 HIGH |
| 9 | Open a parcel | scissors, knife | ~212 | Medium |
| 10 | Serve wine in a glass | wine glass | ~232 | Medium |
| 11 | Pour sugar | spoon | ~228 | Medium |
| 12 | Smear butter on bread | knife | ~224 | Medium |
| 13 | Extinguish a fire | fire hydrant, bottle | ~184 | 🔴 HIGH |
| 14 | Pound a carpet | tennis racket, baseball bat | ~236 | Medium |

**Goal**: Bring every task to ≥350 training images. Focus on tasks 3, 5, 8, 13 first.

---

## 3. Step-by-Step Workflow

### Step 1: Run the Crawling Script

```bash
cd /run/media/user/DATA/DVcon/GatE-V/Software-Architecture/Version1.0.0
.venv/bin/python scripts/crawl_coco_for_tasks.py
```

This will:
- Download COCO 2014 annotations (~241 MB) if not present
- Mine candidate images per task from COCO (filtering out duplicates)
- Download candidate images to `data/crawled_candidates/taskN/`
- Generate `data/crawled_candidates/manifest.json`

### Step 2: Verify Each Candidate Image

For each candidate in the manifest, **look at the image** and apply these rules:

#### Verification Criteria (BE STRICT — Quality Over Quantity)

For a candidate with `task_id=N` and `task_description="..."`:

1. **Does the image contain at least one clearly visible object that could realistically be used to accomplish the task?**
   - The object must match the "Preferred Objects" from the table above
   - Example: For task 3 ("place flowers in a container"), a vase must be visible
   
2. **Is the relevant object clearly visible?**
   - NOT occluded more than 50%
   - NOT smaller than ~32×32 pixels
   - NOT blurry, poorly lit, or cut off at the edge

3. **Would a reasonable adult agree this object is useful for this specific task?**
   - A wine glass IS useful for "serve wine in a glass"
   - A car is NOT useful for "serve wine in a glass"

#### Decision Rules
- **ACCEPT**: All 3 criteria are met → Mark `"status": "accepted"`, `"verdict": "ACCEPT"`
- **REJECT**: Any criterion fails → Mark `"status": "rejected"`, `"verdict": "REJECT"`
- **When in doubt, REJECT.** Quality over quantity.

#### How to Verify

Read `data/crawled_candidates/manifest.json`. For each candidate with `"status": "pending"`:

1. Open the image at `candidate["image_path"]`
2. Apply the 3 criteria above
3. Update the candidate's `"status"` and `"verdict"` in the manifest
4. Save the manifest after each batch of ~20 verifications

You can process tasks one at a time:
```python
# Example: Load manifest, filter task 3, verify
import json
with open("data/crawled_candidates/manifest.json") as f:
    manifest = json.load(f)

for cand in manifest["candidates"]:
    if cand["task_id"] == 3 and cand["status"] == "pending":
        # View image at cand["image_path"]
        # Apply criteria
        cand["verdict"] = "ACCEPT"  # or "REJECT"
        cand["status"] = "accepted"  # or "rejected"

with open("data/crawled_candidates/manifest.json", "w") as f:
    json.dump(manifest, f, indent=2)
```

### Step 3: Integrate Accepted Images

After verification is complete:

```bash
cd /run/media/user/DATA/DVcon/GatE-V/Software-Architecture/Version1.0.0
.venv/bin/python scripts/crawl_coco_for_tasks.py --integrate
```

This will:
- Copy accepted images to `data/images/taskN/train/`
- Resize to 640×640 and save to `data/images_640/taskN/train/`
- Update COCO-Tasks annotation JSONs with proper `preference` labels
- Print updated per-task counts

---

## 4. Critical Rules for Preference Labeling

The crawling script handles preference labeling automatically during integration:

| Task | Category = "preferred" (1) | Category = "not preferred" (0) |
|------|---------------------------|-------------------------------|
| 1 | chair, bench, suitcase | dining table |
| 2 | couch, chair, bench | bed |
| 3 | vase | bottle, bowl, cup, potted plant |
| 4 | fork, spoon | knife, oven |
| 5 | bottle, cup, bowl | potted plant |
| 6 | spoon, fork | knife, cup |
| 7 | umbrella | knife |
| 8 | bottle, knife | wine glass, scissors |
| 9 | scissors, knife | book, handbag |
| 10 | wine glass | cup, bottle |
| 11 | spoon | bowl, cup, bottle |
| 12 | knife | spoon, fork, sandwich |
| 13 | fire hydrant, bottle | bowl |
| 14 | tennis racket, baseball bat | (none) |

**You do NOT need to manually set preference labels.** The script assigns them based on the category mapping above. Your job is only to ACCEPT or REJECT the image.

---

## 5. File Paths Reference

```
/run/media/user/DATA/DVcon/GatE-V/Software-Architecture/Version1.0.0/
├── scripts/
│   └── crawl_coco_for_tasks.py       ← Run this to crawl & integrate
├── data/
│   ├── coco/
│   │   └── annotations/
│   │       └── instances_train2014.json   ← Downloaded by crawl script
│   ├── coco-tasks-dataset/
│   │   └── annotations/
│   │       ├── task_1_train.json          ← Updated during integration
│   │       ├── task_1_test.json           ← NOT modified (test set is fixed)
│   │       └── ...
│   ├── images/
│   │   └── taskN/train/                  ← Original resolution images
│   ├── images_640/
│   │   └── taskN/train/                  ← 640×640 resized (used by training)
│   └── crawled_candidates/
│       ├── manifest.json                 ← Verification manifest (read/write this)
│       ├── task3/                         ← Candidate images
│       ├── task5/
│       ├── task8/
│       └── task13/
└── .venv/                                ← Python virtual environment
```

---

## 6. Troubleshooting

- **Image download fails**: The script retries 3 times. If persistent, check internet connection.
- **PIL/Pillow not found**: Use `.venv/bin/python` (not system Python).
- **Manifest not found**: Run the crawl script first (Step 1).
- **No ACCEPTED candidates**: You were too strict, or the images genuinely aren't relevant. Try a different task.
