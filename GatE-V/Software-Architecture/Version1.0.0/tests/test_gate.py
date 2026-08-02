"""Tests for FGTQGate and MultilevelFGTQGate."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import torch
from src.model.gate import FGTQGate, MultilevelFGTQGate


def test_single_level_gate_shapes():
    """FGTQGate forward pass produces correct output shape."""
    gate = FGTQGate(num_tasks=14, embed_dim=128, feature_channels=2048)
    p5 = torch.randn(2, 2048, 16, 16)
    task_ids = torch.tensor([0, 5])
    out = gate(p5, task_ids)
    assert out.shape == p5.shape, f"Expected {p5.shape}, got {out.shape}"
    print("✓ test_single_level_gate_shapes")


def test_multilevel_gate_shapes():
    """MultilevelFGTQGate produces correct shapes for P3/P4/P5."""
    gate = MultilevelFGTQGate(num_tasks=14, embed_dim=128)
    p3 = torch.randn(2, 512, 64, 64)
    p4 = torch.randn(2, 1024, 32, 32)
    p5 = torch.randn(2, 2048, 16, 16)
    task_ids = torch.tensor([3, 7])
    out = gate([p3, p4, p5], task_ids, levels=["P3", "P4", "P5"])
    assert len(out) == 3
    assert out[0].shape == p3.shape, f"P3: expected {p3.shape}, got {out[0].shape}"
    assert out[1].shape == p4.shape, f"P4: expected {p4.shape}, got {out[1].shape}"
    assert out[2].shape == p5.shape, f"P5: expected {p5.shape}, got {out[2].shape}"
    print("✓ test_multilevel_gate_shapes")


def test_gradient_flow():
    """Gradients flow through MultilevelFGTQGate."""
    gate = MultilevelFGTQGate(num_tasks=14, embed_dim=128)
    p3 = torch.randn(1, 512, 8, 8, requires_grad=True)
    p4 = torch.randn(1, 1024, 4, 4, requires_grad=True)
    p5 = torch.randn(1, 2048, 2, 2, requires_grad=True)
    task_ids = torch.tensor([0])
    out = gate([p3, p4, p5], task_ids)
    loss = sum(o.sum() for o in out)
    loss.backward()
    assert p3.grad is not None, "No gradient for P3"
    assert p4.grad is not None, "No gradient for P4"
    assert p5.grad is not None, "No gradient for P5"
    assert gate.task_embedding.weight.grad is not None, "No gradient for task_embedding"
    print("✓ test_gradient_flow")


def test_learnable_residual_init():
    """Learnable residuals initialized to zero."""
    gate = MultilevelFGTQGate(num_tasks=14, embed_dim=128, use_learnable_residuals=True)
    assert torch.all(gate.task_residual == 0), "Residuals should be zero-initialized"
    print("✓ test_learnable_residual_init")


def test_identity_init():
    """Gate initialized to identity: gamma=1, beta=0 → output ≈ input."""
    gate = MultilevelFGTQGate(num_tasks=14, embed_dim=128, use_learnable_residuals=False)
    # Zero out embeddings so gamma_proj produces bias-only (ones) and beta_proj produces bias-only (zeros)
    with torch.no_grad():
        gate.task_embedding.weight.zero_()
    p5 = torch.randn(1, 2048, 4, 4)
    task_ids = torch.tensor([0])
    out = gate.forward_level(p5, task_ids, "P5")
    assert torch.allclose(out, p5, atol=1e-5), "Gate should be identity at init"
    print("✓ test_identity_init")


if __name__ == "__main__":
    test_single_level_gate_shapes()
    test_multilevel_gate_shapes()
    test_gradient_flow()
    test_learnable_residual_init()
    test_identity_init()
    print("\nAll gate tests passed!")
