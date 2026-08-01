"""TensorBoard + console logging utility."""
from __future__ import annotations

from pathlib import Path


class Logger:
    """Wraps TensorBoard SummaryWriter with console logging."""

    def __init__(self, log_dir: str | Path, log_interval: int = 50):
        self.log_dir = Path(log_dir)
        self.log_dir.mkdir(parents=True, exist_ok=True)
        self.log_interval = log_interval
        self._writer = None
        try:
            from torch.utils.tensorboard import SummaryWriter
            self._writer = SummaryWriter(str(self.log_dir))
        except ImportError:
            print("[logger] TensorBoard not available — console-only logging")

    def scalar(self, tag: str, value: float, step: int):
        if self._writer:
            self._writer.add_scalar(tag, value, step)

    def scalars(self, main_tag: str, tag_dict: dict[str, float], step: int):
        if self._writer:
            self._writer.add_scalars(main_tag, tag_dict, step)

    def log_loss(self, loss_dict: dict[str, float], step: int, prefix: str = "train"):
        for k, v in loss_dict.items():
            self.scalar(f"{prefix}/loss_{k}", v, step)

    def log_lr(self, lr: float, step: int):
        self.scalar("train/lr", lr, step)

    def log_map(self, mean_ap: float, per_task: dict[int, float], step: int):
        self.scalar("val/mAP_0.5", mean_ap, step)
        for tid, ap in per_task.items():
            self.scalar(f"val/task_{tid+1}_AP", ap, step)

    def close(self):
        if self._writer:
            self._writer.close()

    def print_step(self, epoch, total_epochs, step, total_steps, loss_dict, extra=""):
        parts = [f"[{epoch:>2}/{total_epochs}] step {step:>5}/{total_steps}"]
        for k, v in loss_dict.items():
            if k != "total":
                parts.append(f"{k}={v:.4f}")
        if extra:
            parts.append(extra)
        print("  " + "  ".join(parts))
