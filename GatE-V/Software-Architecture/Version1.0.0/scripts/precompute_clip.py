"""Pre-compute CLIP task embeddings.

Usage:
    python scripts/precompute_clip.py --output data/models/task_embeddings.pt
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src.model.gate import precompute_clip_embeddings


def main():
    parser = argparse.ArgumentParser(description="Pre-compute CLIP task embeddings")
    parser.add_argument(
        "--output", type=str,
        default="data/models/task_embeddings.pt",
        help="Output path for embeddings .pt file",
    )
    args = parser.parse_args()
    output = ROOT / args.output if not Path(args.output).is_absolute() else Path(args.output)
    precompute_clip_embeddings(output)


if __name__ == "__main__":
    main()
