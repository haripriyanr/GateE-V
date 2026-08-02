"""Pre-resize all images to 512x512 to speed up training dataloading.

This script finds all images in the source directory, resizes them to the
target dimension (e.g., 512x512) using Bilinear interpolation, and saves
them to a new destination directory.

Usage:
    python scripts/precompute_images.py
"""
import argparse
import multiprocessing
from pathlib import Path

from PIL import Image
from tqdm import tqdm


def process_image(args: tuple[Path, Path, int]) -> None:
    src_path, dst_path, img_size = args
    if dst_path.exists():
        return
    try:
        dst_path.parent.mkdir(parents=True, exist_ok=True)
        with Image.open(src_path) as img:
            img = img.convert("RGB")
            # Only resize if it's not already the target size
            if img.size != (img_size, img_size):
                img = img.resize((img_size, img_size), Image.BILINEAR)
            img.save(dst_path, format="JPEG", quality=95)
    except Exception as e:
        print(f"Error processing {src_path}: {e}")


def main():
    parser = argparse.ArgumentParser(description="Pre-resize images for faster training")
    parser.add_argument("--src_dir", type=str, default="./data/images",
                        help="Source directory containing the original images")
    parser.add_argument("--dst_dir", type=str, default="./data/images_512",
                        help="Destination directory for resized images")
    parser.add_argument("--img_size", type=int, default=512,
                        help="Target image size (width and height)")
    parser.add_argument("--num_workers", type=int, default=16,
                        help="Number of parallel workers for processing")
    args = parser.parse_args()

    src_dir = Path(args.src_dir)
    dst_dir = Path(args.dst_dir)

    print(f"Gathering image paths from {src_dir}...")
    tasks = []
    for ext in ["*.jpg", "*.jpeg", "*.png", "*.JPG"]:
        for p in src_dir.rglob(ext):
            rel_path = p.relative_to(src_dir)
            dst_path = dst_dir / rel_path
            # Change extension to .jpg since we save as JPEG
            dst_path = dst_path.with_suffix(".jpg")
            tasks.append((p, dst_path, args.img_size))

    if not tasks:
        print(f"No images found in {src_dir}.")
        return

    print(f"Found {len(tasks)} images. Resizing to {args.img_size}x{args.img_size}...")
    
    with multiprocessing.Pool(args.num_workers) as pool:
        list(tqdm(pool.imap_unordered(process_image, tasks), total=len(tasks)))

    print(f"\nDone! Resized images are saved to {dst_dir}.")
    print("Don't forget to update 'images_dir' in your config file (configs/gatev_base.yaml) to point to this new directory!")


if __name__ == "__main__":
    main()
