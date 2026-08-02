#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "\n${MAGENTA}==============================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${MAGENTA}==============================================${NC}"
}
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

DATA_ONLY=false
TRAIN_ONLY=false
FRESH=false
CLEAN_VENV=false
TRAIN_ARGS=(--config configs/gatev_v1.0.0.yaml)
OVERRIDES=()

USE_MENU=false
if [ $# -eq 0 ]; then
  USE_MENU=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean-venv)
      CLEAN_VENV=true
      shift
      ;;
    --data-only)
      DATA_ONLY=true
      shift
      ;;
    --train-only)
      TRAIN_ONLY=true
      shift
      ;;
    --fresh)
      FRESH=true
      shift
      ;;
    --debug)
      OVERRIDES+=(data.max_samples_debug=100)
      OVERRIDES+=(training.stage1.epochs=2)
      OVERRIDES+=(training.stage2.epochs=2)
      OVERRIDES+=(validation.max_samples_per_task=10)
      shift
      ;;
    --compile)
      OVERRIDES+=(training.use_compile=true)
      shift
      ;;
    --no-compile)
      OVERRIDES+=(training.use_compile=false)
      shift
      ;;
    --batch-size)
      if [[ $# -lt 2 ]]; then
        echo "--batch-size requires a value"
        exit 1
      fi
      OVERRIDES+=("training.batch_size=$2")
      shift 2
      ;;
    --workers)
      if [[ $# -lt 2 ]]; then
        echo "--workers requires a value"
        exit 1
      fi
      OVERRIDES+=("data.num_workers=$2")
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./run.sh [--data-only] [--train-only] [--fresh] [--clean-venv] [--debug] [--no-compile] [--batch-size N] [--workers N]"
      exit 1
      ;;
  esac
done

if [ "$FRESH" = true ]; then
  TRAIN_ARGS+=(--fresh)
fi
if [ ${#OVERRIDES[@]} -gt 0 ]; then
  TRAIN_ARGS+=(--override "${OVERRIDES[@]}")
fi

DO_SETUP=true; DO_MIRROR=true; DO_DOWNLOAD=true; DO_PRECOMPUTE=true; DO_TRAIN=true
if [ "$USE_MENU" = true ]; then
  DO_MIRROR=false
  DO_DOWNLOAD=false
  DO_PRECOMPUTE=false
  DO_TRAIN=false
fi
if [ "$DATA_ONLY" = true ]; then
  DO_TRAIN=false
fi
if [ "$TRAIN_ONLY" = true ]; then
  DO_SETUP=false; DO_MIRROR=false; DO_DOWNLOAD=false; DO_PRECOMPUTE=false
fi

if [ "$DO_SETUP" = true ]; then
  print_header "Environment Setup"
  if ! command -v uv &> /dev/null; then
    print_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh
  fi

  if [ "$CLEAN_VENV" = true ]; then
    print_info "Cleaning existing virtual environment..."
    rm -rf .venv
  fi

  if [ ! -d ".venv" ]; then
    print_info "Creating virtual environment..."
    uv venv
  fi

  print_info "Installing dependencies..."
  uv pip install --python .venv/bin/python -r requirements.txt

  print_info "Checking Torch installation (CPU vs GPU)..."
  .venv/bin/python scripts/bootstrap.py --install-torch
  print_success "Environment ready."
fi

if [ "$DO_MIRROR" = true ]; then
  print_header "Mirroring Data"
  .venv/bin/python scripts/bootstrap.py --mirror-data
fi

if [ "$DO_DOWNLOAD" = true ]; then
  print_header "Downloading COCO images"
  .venv/bin/python scripts/bootstrap.py --download-images
fi

if [ "$DO_PRECOMPUTE" = true ]; then
  print_header "Precomputing 800px images"
  .venv/bin/python scripts/bootstrap.py --precompute-images
fi

if [ "$DO_TRAIN" = true ]; then
  print_header "Checking Backbone Model"
  if [ ! -f "pretrained/rtdetrv2_r50vd_m_7x_coco_ema.pth" ]; then
    print_info "Downloading RT-DETRv2 ResNet-50vd backbone..."
    mkdir -p pretrained
    curl -L -o pretrained/rtdetrv2_r50vd_m_7x_coco_ema.pth "https://github.com/lyuwenyu/storage/releases/download/v0.1/rtdetrv2_r50vd_m_7x_coco_ema.pth"
  else
    print_success "Backbone model found locally."
  fi

  print_header "Starting training"
  .venv/bin/python -u scripts/train.py "${TRAIN_ARGS[@]}" "${OVERRIDES[@]}"
fi

if [ "$DATA_ONLY" = true ]; then
  print_success "Data preparation complete. Ready for GPU."
fi

if [ "$USE_MENU" = true ]; then
  print_header "Launching Interactive Menu..."
  .venv/bin/python -u scripts/bootstrap.py
fi
