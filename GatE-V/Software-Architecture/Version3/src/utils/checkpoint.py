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
        self.best_metric = -float("inf")
        best_path = self.save_dir / "best.pth"
        if best_path.exists():
            try:
                ckpt = torch.load(best_path, map_location="cpu", weights_only=False)
                self.best_metric = ckpt.get("metric", -float("inf"))
                print(f"[checkpoint] Loaded historical best metric: {self.best_metric:.4f}")
            except Exception:
                pass

    def set_best_metric(self, metric: float) -> None:
        """Seed best metric from resumed checkpoint so we don't overwrite best.pth."""
        self.best_metric = max(self.best_metric, metric)

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
        """Save checkpoint. Returns path if metric is best-so-far, else None."""
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

        # Clean up old per-epoch best files from previous sessions
        for old in self.save_dir.glob("best_epoch*.pth"):
            try:
                old.unlink()
            except OSError:
                pass

        # Save best if metric improved
        if metric > self.best_metric:
            self.best_metric = max(self.best_metric, metric)
            best_path = self.save_dir / "best.pth"
            torch.save(state, best_path)
            print(f"  [ckpt] New best mAP={metric:.4f} at epoch {epoch}")
            return best_path

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
        self.set_best_metric(metric)
        return epoch
