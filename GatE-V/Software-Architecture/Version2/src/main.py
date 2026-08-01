"""GatE-V bootstrap + interactive menu.

Handles environment setup and delegates to the modular pipeline:
  t → train       scripts/train.py
  e → evaluate    scripts/eval.py
  x → export      scripts/export.py  (ONNX)
  m → mirror      dataset annotations from GitHub
  i → images      download COCO images
  q → quit

Direct CLI (non-interactive):
  python scripts/train.py --config configs/vega_base.yaml
  python scripts/eval.py  --checkpoint runs/vega_base/checkpoints/best.pth
  python scripts/export.py --checkpoint runs/vega_base/vega_edge_detect_final.pth
"""
from __future__ import annotations

import json
import platform
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from urllib.parse import quote
from urllib.request import Request, urlopen

ROOT_DIR = Path(__file__).resolve().parent.parent
SCRIPTS  = ROOT_DIR / "scripts"   # scripts/ is at root level
PYTHON   = sys.executable


# ── PyTorch installer ─────────────────────────────────────────────────────

CUDA_INDEX = {
    "cu130": "https://download.pytorch.org/whl/cu130",
    "cu128": "https://download.pytorch.org/whl/cu128",
    "cu126": "https://download.pytorch.org/whl/cu126",
    "cu124": "https://download.pytorch.org/whl/cu124",
    "cu121": "https://download.pytorch.org/whl/cu121",
    "cu118": "https://download.pytorch.org/whl/cu118",
}
ROCM_INDEX = {
    "rocm7.2": "https://download.pytorch.org/whl/rocm7.2",
    "rocm6.3":  "https://download.pytorch.org/whl/rocm6.3",
}
CPU_INDEX = "https://download.pytorch.org/whl/cpu"


@dataclass
class InstallPlan:
    backend: str
    index_url: str | None
    reason: str


def _run(cmd): return subprocess.run(cmd, capture_output=True, text=True, check=False)
def _has(name): return shutil.which(name) is not None


def _cuda_ver():
    if not _has("nvidia-smi"): return None
    m = re.search(r"CUDA Version:\s*(\d+\.\d+)", _run(["nvidia-smi"]).stdout)
    return m.group(1) if m else None


def _best_cuda_tag(ver):
    tags = sorted(CUDA_INDEX.keys(), key=lambda t: int(t[2:]), reverse=True)
    if not ver: return tags[0]
    try: key = int(ver.split(".")[0]) * 10 + int(ver.split(".")[1])
    except Exception: return tags[0]
    return next((t for t in tags if int(t[2:]) <= key), tags[-1])


def detect_torch_plan(force_backend=None, cpu_only=False) -> InstallPlan:
    if cpu_only: return InstallPlan("cpu", CPU_INDEX, "CPU-only")
    if force_backend == "cuda":
        tag = _best_cuda_tag(_cuda_ver())
        return InstallPlan("cuda", CUDA_INDEX[tag], f"Forced CUDA ({tag})")
    if _has("nvidia-smi"):
        tag = _best_cuda_tag(_cuda_ver())
        return InstallPlan("cuda", CUDA_INDEX[tag], "NVIDIA GPU")
    if platform.system() == "Darwin":
        return InstallPlan("mps", None, "macOS MPS")
    return InstallPlan("cpu", CPU_INDEX, "No GPU")


def install_torch(plan: InstallPlan) -> int:
    print(f"[torch] {plan.backend} ({plan.reason})")
    uv = shutil.which("uv") or "uv"
    cmd = [uv, "pip", "install", "--python", PYTHON, "--upgrade"]
    if plan.index_url: cmd += ["--index-url", plan.index_url]
    cmd += ["torch", "torchvision", "torchaudio"]
    print(f"[torch] Running: {' '.join(cmd)}")
    return subprocess.call(cmd)


def verify_torch() -> int:
    try:
        import torch
    except ImportError:
        print("[torch] PyTorch not installed.")
        return 1
    print(f"[torch] {torch.__version__}")
    accel = []
    if torch.cuda.is_available(): accel.append("CUDA")
    if hasattr(torch.backends, "mps") and torch.backends.mps.is_available(): accel.append("MPS")
    print(f"[torch] Accelerators: {', '.join(accel) or 'None (CPU)'}")
    return 0


# ── Dataset utilities ─────────────────────────────────────────────────────

DATASET_REPO   = "coco-tasks/dataset"
DATASET_BRANCH = "master"


def mirror_dataset(target_dir: Path, force: bool = False) -> None:
    print(f"[dataset] Mirroring to {target_dir}")
    target_dir.mkdir(parents=True, exist_ok=True)

    def fetch_json(url):
        req = Request(url, headers={"User-Agent": "GatE-V"})
        with urlopen(req, timeout=120) as r: return json.loads(r.read())

    tree = fetch_json(
        f"https://api.github.com/repos/{DATASET_REPO}/git/trees/{DATASET_BRANCH}?recursive=1"
    )
    for item in tree.get("tree", []):
        if item.get("type") != "blob": continue
        path = item["path"]
        dest = target_dir / path
        if dest.exists() and not force: continue
        url = f"https://raw.githubusercontent.com/{DATASET_REPO}/{DATASET_BRANCH}/{quote(path)}"
        print(f"[dataset] {path}")
        dest.parent.mkdir(parents=True, exist_ok=True)
        try:
            with urlopen(Request(url, headers={"User-Agent": "GatE-V"})) as r, \
                 dest.open("wb") as f:
                import shutil as sh; sh.copyfileobj(r, f)
        except Exception as e:
            print(f"[dataset] Error {path}: {e}")


def download_coco_images(dataset_dir: Path, images_dir: Path) -> None:
    try:
        import requests
        from pycocotools.coco import COCO
        from tqdm import tqdm
    except ImportError:
        print("[images] Missing deps: pip install tqdm pycocotools requests")
        return

    session = requests.Session()
    adapter = requests.adapters.HTTPAdapter(pool_connections=50, pool_maxsize=50)
    session.mount("http://", adapter); session.mount("https://", adapter)

    def _dl(img_info, dest):
        tgt = dest / img_info["file_name"]
        if tgt.exists() and tgt.stat().st_size > 0: return
        url = img_info.get("coco_url") or img_info.get("flickr_url")
        if not url: return
        try:
            r = session.get(url, timeout=30, stream=True)
            if r.status_code == 200:
                with tgt.open("wb") as f:
                    for chunk in r.iter_content(65536): f.write(chunk)
        except Exception: pass

    for task_id in range(1, 15):
        for split in ["train", "test"]:
            ann = dataset_dir / "annotations" / f"task_{task_id}_{split}.json"
            if not ann.exists(): continue
            
            # Safe JSON validation check
            try:
                # First, ensure file is not empty or a Git LFS placeholder
                if ann.stat().st_size < 1000:
                    with ann.open("r", encoding="utf-8") as f:
                        header = f.read(200)
                    if "version https://git-lfs" in header or len(header.strip()) == 0:
                        raise ValueError("File is an un-pulled Git LFS pointer or empty placeholder.")
                coco = COCO(str(ann))
            except Exception as e:
                print(f"\n[ERROR] Failed to load annotation file: {ann.name}")
                print(f"Details: {e}")
                print("\n💡 POSSIBLE ROOT CAUSE & SOLUTION:")
                print("1. Your downloaded repository is using Git LFS (Large File Storage), but the actual JSON files were not pulled.")
                print("   👉 Fix: Run `git lfs pull` in your repository terminal to fetch the actual files.")
                print("2. The downloaded zip file did not include large LFS files.")
                print("   👉 Fix: Download the full dataset files directly from the release page or project source.")
                print("3. The file is corrupted or empty.")
                print("   👉 Fix: Delete the 'data/' directory and redownload/restore the dataset annotations.\n")
                sys.exit(1)
            dest = images_dir / f"task{task_id}" / split
            dest.mkdir(parents=True, exist_ok=True)
            imgs = list(coco.imgs.values())
            print(f"[images] Task {task_id} {split}: {len(imgs)}")
            with ThreadPoolExecutor(max_workers=50) as ex:
                futs = [ex.submit(_dl, img, dest) for img in imgs]
                with tqdm(total=len(futs), desc=f"Task{task_id}"):
                    for f in as_completed(futs): f.result()


# ── Sub-process runners ───────────────────────────────────────────────────

def _run_script(script: str, *extra_args: str) -> None:
    """Run one of the scripts/ entry points in the same venv."""
    script_path = ROOT_DIR / "scripts" / script
    cmd = [PYTHON, str(script_path)] + list(extra_args)
    print(f"\n[run] {' '.join(cmd)}\n")
    subprocess.call(cmd)


def run_train() -> None:
    _run_script("train.py", "--config", "configs/vega_base.yaml")


def run_eval() -> None:
    # Find best checkpoint automatically
    best = ROOT_DIR / "runs" / "vega_base" / "checkpoints" / "best.pth"
    final = ROOT_DIR / "runs" / "vega_base" / "vega_edge_detect_final.pth"
    ckpt = str(best) if best.exists() else str(final) if final.exists() else None
    if ckpt is None:
        print("[eval] No checkpoint found. Train the model first (option t).")
        return
    _run_script("eval.py", "--config", "configs/vega_base.yaml", "--checkpoint", ckpt)


def run_export() -> None:
    final = ROOT_DIR / "runs" / "vega_base" / "vega_edge_detect_final.pth"
    best  = ROOT_DIR / "runs" / "vega_base" / "checkpoints" / "best.pth"
    ckpt  = str(final) if final.exists() else str(best) if best.exists() else None
    if ckpt is None:
        print("[export] No checkpoint found. Train first (option t).")
        return
    _run_script("export.py", "--config", "configs/vega_base.yaml", "--checkpoint", ckpt)


def run_precompute() -> None:
    # Uses 640x640 as that is the configured full resolution
    _run_script("precompute_images.py", "--src_dir", "./data/images", "--dst_dir", "./data/images_640", "--img_size", "640")


def run_optimize() -> None:
    final = ROOT_DIR / "runs" / "vega_base" / "vega_edge_detect_final.pth"
    best  = ROOT_DIR / "runs" / "vega_base" / "checkpoints" / "best.pth"
    ckpt  = str(final) if final.exists() else str(best) if best.exists() else None
    if ckpt is None:
        print("[optimize] No checkpoint found. Train first (option t).")
        return
    _run_script("optimize_gating.py", "--config", "configs/vega_base.yaml", "--checkpoint", ckpt)


def run_gui() -> None:
    _run_script("gui_visualizer.py")



# ── Interactive menu ──────────────────────────────────────────────────────

def safe_input(prompt):
    try: return input(prompt)
    except EOFError: return None


def show_menu():
    print()
    print("=" * 48)
    print("  GatE-V  —  DVCon India 2026")
    print("=" * 48)
    print("  t. Train model")
    print("  e. Evaluate model   (mAP@0.5)")
    print("  x. Export model     (ONNX)")
    print("  o. Optimize gating  (Threshold search)")
    print("  v. Visualize GUI    (CPU comparison)")
    print("  p. Precompute images (Resize)")
    print("  m. Mirror dataset   (annotations)")
    print("  i. Download images  (COCO)")
    print("  q. Quit")
    print("-" * 48)


def main() -> int:
    # Non-interactive bootstrap flags (called by run.sh)
    if "--install-torch" in sys.argv:
        return install_torch(detect_torch_plan()) or verify_torch()
    if "--verify-torch" in sys.argv:
        return verify_torch()

    while True:
        show_menu()
        choice = safe_input("  Select: ")
        if choice is None:
            return 0
        choice = choice.strip().lower()
        if choice == "q":
            return 0
        elif choice == "t":
            run_train()
        elif choice == "e":
            run_eval()
        elif choice == "x":
            run_export()
        elif choice == "o":
            run_optimize()
        elif choice == "v":
            run_gui()
        elif choice == "p":
            run_precompute()
        elif choice == "m":
            mirror_dataset(ROOT_DIR / "data" / "coco-tasks-dataset")
        elif choice == "i":
            download_coco_images(
                ROOT_DIR / "data" / "coco-tasks-dataset",
                ROOT_DIR / "data" / "images",
            )
        else:
            print("  Unknown option.")

        safe_input("\n  Press Enter to continue...")


if __name__ == "__main__":
    sys.exit(main())
