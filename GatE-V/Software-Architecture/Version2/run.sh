#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

echo "[1/4] Checking for uv..."
if ! command -v uv >/dev/null 2>&1; then
  echo "[bootstrap] uv not found. Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is still not available in PATH."
  echo "Restart your terminal and run this script again."
  exit 1
fi

echo "[2/4] Ensuring virtual environment exists..."
if [ ! -d ".venv" ]; then
  uv venv
else
  echo "Reusing existing virtual environment."
fi

echo "[3/4] Installing dependencies..."
uv pip install -r requirements.txt

echo "[4/4] Installing/Verifying PyTorch..."
uv run src/main.py --install-torch

echo "Launching GatE-V..."
uv run src/main.py
