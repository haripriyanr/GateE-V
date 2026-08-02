"""Real-time training monitor: parses TensorBoard events and shows live dashboard.

Usage:
    python scripts/monitor.py                                    # default: runs/vega_v3/logs
    python scripts/monitor.py --logdir runs/vega_v3/logs         # explicit path
    python scripts/monitor.py --plot                             # also save loss curves PNG
"""

from __future__ import annotations

import argparse
import os
import time
from pathlib import Path

import numpy as np

try:
    from tensorboard.backend.event_processing.event_accumulator import EventAccumulator
except ImportError:
    print("[monitor] tensorboard not installed. Run: pip install tensorboard")
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parent.parent
LOSS_KEYS = ("cls", "bbox", "giou", "task", "noobj", "exists", "comp", "total")
VAL_KEY = "val/mAP_0.5"
LR_KEY = "stage2/lr"


def _resolve_logdir(logdir: str | None) -> Path:
    if logdir:
        return Path(logdir)
    runs_dir = ROOT / "runs"
    if not runs_dir.exists():
        print("[monitor] No runs/ directory found. Has training started?")
        raise SystemExit(1)
    dirs = sorted(runs_dir.iterdir())
    if not dirs:
        print("[monitor] No experiment directories in runs/. Start training first.")
        raise SystemExit(1)
    latest = dirs[-1]
    logdir = latest / "logs"
    if not logdir.exists():
        print(f"[monitor] No logs/ dir in {latest}. Training may not have logged yet.")
        raise SystemExit(1)
    return logdir


def _load_events(logdir: Path):
    ea = EventAccumulator(str(logdir), size_guidance={"scalars": 0})
    ea.Reload()
    tags = ea.Tags().get("scalars", [])
    data = {}
    for tag in tags:
        events = ea.Scalars(tag)
        vals = [(e.step, e.value) for e in events]
        data[tag] = vals
    return data


def _trend(current: float, avg: float) -> str:
    if avg == 0:
        return "→"
    ratio = (current - avg) / abs(avg)
    if ratio < -0.02:
        return "↓"
    elif ratio > 0.02:
        return "↑"
    return "→"


def _format_time(seconds: float) -> str:
    h, rem = divmod(int(seconds), 3600)
    m, s = divmod(rem, 60)
    return f"{h}h{m:02d}m" if h else f"{m}m{s:02d}s"


def _find_latest_val(data):
    """Get the latest validation mAP and which epoch it was."""
    vals = data.get(VAL_KEY, [])
    if not vals:
        return None, None, None
    step, latest = vals[-1]
    best_step, best = max(vals, key=lambda x: x[1])
    return step, latest, best


def _infer_eta(data, total_epochs: int):
    steps = data.get("stage2/loss_total", [])
    if len(steps) < 200:
        return "?"
    first_step = steps[0][0]
    last_step = steps[-1][0]
    elapsed = first_step and last_step and last_step - first_step
    if elapsed and elapsed > 0:
        total_steps = total_epochs * 1575
        remaining = total_steps - last_step
        rate = max(1, last_step) / (time.time() - _start_time)
        return _format_time(remaining / rate) if rate > 0 else "?"
    return "?"


_start_time = time.time()


def _safe_get(data, key, default=[]):
    return data.get(key, default)


def _recent_mean(data, key, n=100):
    vals = _safe_get(data, key)
    if len(vals) < 5:
        return None
    return np.mean([v for _, v in vals[-n:]])


def _current_val(data, key):
    vals = _safe_get(data, key)
    return vals[-1][1] if vals else None


def show_dashboard(data):
    os.system("clear" if os.name == "posix" else "cls")

    # Header
    print("╔══════════════════════════════════════════════════════════╗")
    print("║              GatE-V Training Monitor                    ║")
    elapsed = time.time() - _start_time
    print(f"║  {'Refresh every 10s':<35} Elapsed: {_format_time(elapsed):>8s} ║")
    print("╚══════════════════════════════════════════════════════════╝")
    print()

    # Loss table
    print(f"  {'Component':<12} {'Current':>10} {'Avg(100)':>10} {'Trend':>6}")
    print(f"  {'─' * 42}")
    for key in LOSS_KEYS:
        tag = f"stage2/loss_{key}" if key != "total" else "stage2/loss_total"
        if key == "total":
            tag = "stage2/loss_total"
        cur = _current_val(data, tag)
        avg = _recent_mean(data, tag, 100)
        if cur is not None:
            trend = _trend(cur, avg or cur)
            avg_str = f"{avg:.4f}" if avg else "—"
            print(f"  {key:<12} {cur:>10.4f} {avg_str:>10} {trend:>6}")

    print()

    # Validation
    print(f"  {' Validation':<30} {'Latest':>10} {'Best':>10}")
    print(f"  {'─' * 54}")
    step, latest, best = _find_latest_val(data)
    if step is not None:
        ep = step // 1575 if step > 0 else 0
        best_ep = best and "?"
        print(f"  {'mAP@0.5 (val)':<30} {latest:>10.4f} {best:>10.4f}")
        print(f"  {'— epoch':<30} {ep:>10} {'':>10}")
    else:
        print(f"  {'mAP@0.5 (val)':<30} {'—':>10} {'—':>10}")
    print()

    # Per-task AP
    per_task = {tid: _current_val(data, f"val/task_{tid}_AP") for tid in range(1, 15)}
    if any(v is not None for v in per_task.values()):
        line = "  Per-task AP: "
        for tid, ap in sorted(per_task.items()):
            v = f"{ap:.4f}" if ap else "—"
            line += f"T{tid}:{v} "
        print(line[:120])
        print()

    # LR and ETA
    lr_vals = _safe_get(data, LR_KEY)
    lr = lr_vals[-1][1] if lr_vals else 0
    print(f"  LR: {lr:.2e}  |  ETA: {_infer_eta(data, 90)}  |  Refresh every 10s  [Ctrl+C to quit]")


def save_plot(data, save_path: Path):
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        print("[monitor] matplotlib not installed, skipping plot.")
        return

    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    fig.suptitle("GatE-V Training Curves", fontsize=14)

    # 1. Loss components
    ax = axes[0, 0]
    colors = {"cls": "#2196F3", "bbox": "#4CAF50", "giou": "#FF9800",
               "task": "#E91E63", "noobj": "#9C27B0", "exists": "#00BCD4",
               "comp": "#FF5722", "total": "#F44336"}
    has_loss = False
    for key in LOSS_KEYS:
        tag = f"stage2/loss_{key}" if key != "total" else "stage2/loss_total"
        vals = _safe_get(data, tag)
        if vals:
            steps, vals = zip(*vals)
            step_st = steps[0]
            ax.plot([s - step_st for s in steps], vals, label=key.upper(), color=colors.get(key, "gray"), alpha=0.7)
            has_loss = True
    if has_loss:
        ax.set_xlabel("Step (from start)")
        ax.set_ylabel("Loss")
        ax.legend(fontsize=8)
        ax.grid(alpha=0.3)
    ax.set_title("Loss Components")

    # 2. mAP
    ax = axes[0, 1]
    vals = _safe_get(data, VAL_KEY)
    if vals:
        steps, mAPs = zip(*vals)
        ep = [s // 1575 if s > 0 else 0 for s in steps]
        ax.plot(ep, mAPs, "o-", color="#4CAF50", markersize=4)
        ax.set_xlabel("Epoch")
        ax.set_ylabel("mAP@0.5")
        ax.grid(alpha=0.3)
    ax.set_title("Validation mAP")

    # 3. Learning rate
    ax = axes[1, 0]
    vals = _safe_get(data, LR_KEY)
    if vals:
        steps, lrs = zip(*vals)
        ax.plot(steps, lrs, color="#FF9800")
        ax.set_xlabel("Step")
        ax.set_ylabel("LR")
        ax.grid(alpha=0.3)
    ax.set_title("Learning Rate")

    # 4. Per-task AP
    ax = axes[1, 1]
    task_aps = {}
    for tid in range(1, 15):
        vals = _safe_get(data, f"val/task_{tid}_AP")
        if vals:
            task_aps[tid] = vals[-1][1]
    if task_aps:
        tids = sorted(task_aps.keys())
        aps = [task_aps[t] for t in tids]
        bars = ax.bar(tids, aps, color="#2196F3", alpha=0.7)
        for bar, ap in zip(bars, aps):
            ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.001,
                    f"{ap:.4f}", ha="center", va="bottom", fontsize=7)
        ax.set_xlabel("Task ID")
        ax.set_ylabel("AP@0.5")
    ax.set_title("Per-Task AP (Latest)")

    plt.tight_layout()
    save_path.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"[monitor] Plot saved → {save_path}")


def _find_total_epochs(data) -> int:
    try:
        from src.utils.config import GatEVConfig
        cfg = GatEVConfig.from_yaml(str(ROOT / "configs" / "gatev_base.yaml"))
        return cfg.training.stage2.epochs
    except Exception:
        return 90


def main():
    parser = argparse.ArgumentParser(description="GatE-V Real-time Training Monitor")
    parser.add_argument("--logdir", type=str, default=None,
                        help="Path to TensorBoard log directory (auto-detected if omitted)")
    parser.add_argument("--plot", action="store_true",
                        help="Save loss/mAP curves as PNG after each refresh")
    parser.add_argument("--interval", type=int, default=10,
                        help="Refresh interval in seconds (default: 10)")
    args = parser.parse_args()

    logdir = _resolve_logdir(args.logdir)
    print(f"[monitor] Watching: {logdir}")
    print(f"[monitor] Refresh: {args.interval}s  |  Plot: {'Yes' if args.plot else 'No'}")
    print("[monitor] Press Ctrl+C to stop.\n")

    try:
        while True:
            data = _load_events(logdir)
            show_dashboard(data)
            if args.plot:
                plot_path = logdir.parent / "training_curves.png"
                save_plot(data, plot_path)
            time.sleep(args.interval)
    except KeyboardInterrupt:
        print("\n[monitor] Stopped.")
        if args.plot:
            data = _load_events(logdir)
            plot_path = logdir.parent / "training_curves.png"
            save_plot(data, plot_path)
            print(f"[monitor] Final plot → {plot_path}")
        raise SystemExit(0)


if __name__ == "__main__":
    main()
