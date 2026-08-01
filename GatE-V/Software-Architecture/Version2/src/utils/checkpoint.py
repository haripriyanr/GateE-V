"""Checkpoint save/load with EMA and top-K management."""
from __future__ import annotations

import copy
from pathlib import Path

import torch
import torch.nn as nn


class ModelEMA:
    """Exponential Moving Average of model parameters."""

    def __init__(self, model: nn.Module, decay: float = 0.999):
        self.ema = copy.deepcopy(model)
        self.ema.eval()
        self.decay = decay
        for p in self.ema.parameters():
            p.requires_grad_(False)

    @torch.no_grad()
    def update(self, model: nn.Module):
        for ema_p, model_p in zip(self.ema.parameters(), model.parameters()):
            ema_p.data.mul_(self.decay).add_(model_p.data, alpha=1 - self.decay)

    def state_dict(self):
        return self.ema.state_dict()

    def load_state_dict(self, state_dict):
        self.ema.load_state_dict(state_dict)


class CheckpointManager:
    """Manages top-K checkpoint saving and auto-resume."""

    def __init__(self, save_dir: str | Path, top_k: int = 3):
        self.save_dir = Path(save_dir)
        self.save_dir.mkdir(parents=True, exist_ok=True)
        self.top_k = top_k
        self.best_checkpoints: list[tuple[float, Path]] = []

    def save(
        self,
        model: nn.Module,
        optimizer,
        scheduler,
        epoch: int,
        metric: float,
        ema: ModelEMA | None = None,
        scaler=None,
        extra: dict | None = None,
    ) -> Path | None:
        """Save checkpoint if metric is in top-K. Returns path or None."""
        state = {
            "model": model.state_dict(),
            "optimizer": optimizer.state_dict(),
            "scheduler": scheduler.state_dict(),
            "epoch": epoch,
            "metric": metric,
        }
        if ema is not None:
            state["ema"] = ema.state_dict()
        if scaler is not None:
            state["scaler"] = scaler.state_dict()
        if extra:
            state.update(extra)

        # Always save latest
        latest_path = self.save_dir / "latest.pth"
        torch.save(state, latest_path)

        # Check if this metric qualifies for top-K
        if len(self.best_checkpoints) < self.top_k or metric > self.best_checkpoints[-1][0]:
            ckpt_path = self.save_dir / f"best_epoch{epoch}_map{metric:.4f}.pth"
            torch.save(state, ckpt_path)

            self.best_checkpoints.append((metric, ckpt_path))
            self.best_checkpoints.sort(key=lambda x: x[0], reverse=True)

            # Remove excess checkpoints
            while len(self.best_checkpoints) > self.top_k:
                _, old_path = self.best_checkpoints.pop()
                if old_path.exists():
                    old_path.unlink()

            # Symlink to best
            best_link = self.save_dir / "best.pth"
            if best_link.exists() or best_link.is_symlink():
                best_link.unlink()
            best_link.symlink_to(self.best_checkpoints[0][1].name)

            return ckpt_path
        return None

    def load_latest(self, model, optimizer=None, scheduler=None,
                    ema=None, scaler=None) -> int:
        """Resume from latest checkpoint. Returns the epoch to resume from."""
        latest = self.save_dir / "latest.pth"
        if not latest.exists():
            return 0

        print(f"[checkpoint] Resuming from {latest}")
        try:
            state = torch.load(latest, map_location="cpu", weights_only=False)
        except Exception as e:
            print(f"[checkpoint] Failed to load {latest}: {e}")
            # Try best checkpoint as fallback
            best = self.save_dir / "best.pth"
            if best.exists():
                print(f"[checkpoint] Falling back to {best}")
                state = torch.load(best, map_location="cpu", weights_only=False)
            else:
                return 0

        model.load_state_dict(state["model"])
        if optimizer and "optimizer" in state:
            optimizer.load_state_dict(state["optimizer"])
        if scheduler and "scheduler" in state:
            scheduler.load_state_dict(state["scheduler"])
        if ema and "ema" in state:
            ema.load_state_dict(state["ema"])
        if scaler and "scaler" in state:
            scaler.load_state_dict(state["scaler"])

        epoch = state.get("epoch", 0)
        metric = state.get("metric", 0.0)
        print(f"[checkpoint] Resumed at epoch {epoch}, metric={metric:.4f}")
        return epoch
