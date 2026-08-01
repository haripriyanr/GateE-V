"""Tests for Hungarian matcher."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import torch
from src.model.matcher import hungarian_match, box_cxcywh_to_xyxy, safe_boxes_xyxy


def test_basic_matching():
    """Basic matching: 2 queries, 1 GT box → 1 match."""
    pred_logits = torch.tensor([[[2.0], [-1.0]]])  # (1, 2, 1)
    pred_boxes = torch.tensor([[[0.5, 0.5, 0.2, 0.2], [0.1, 0.1, 0.1, 0.1]]])
    targets = [{"boxes": torch.tensor([[0.5, 0.5, 0.2, 0.2]])}]
    indices = hungarian_match(pred_logits, pred_boxes, targets)
    assert len(indices) == 1
    pred_idx, tgt_idx = indices[0]
    assert len(pred_idx) == 1 and len(tgt_idx) == 1
    print("✓ test_basic_matching")


def test_empty_gt():
    """Empty GT → empty match indices."""
    pred_logits = torch.randn(1, 10, 1)
    pred_boxes = torch.rand(1, 10, 4)
    targets = [{"boxes": torch.zeros(0, 4)}]
    indices = hungarian_match(pred_logits, pred_boxes, targets)
    pred_idx, tgt_idx = indices[0]
    assert len(pred_idx) == 0 and len(tgt_idx) == 0
    print("✓ test_empty_gt")


def test_batch_matching():
    """Batch of 2 images with different GT counts."""
    pred_logits = torch.randn(2, 5, 1)
    pred_boxes = torch.rand(2, 5, 4).clamp(0.01, 0.99)
    targets = [
        {"boxes": torch.tensor([[0.3, 0.3, 0.1, 0.1], [0.7, 0.7, 0.2, 0.2]])},
        {"boxes": torch.tensor([[0.5, 0.5, 0.15, 0.15]])},
    ]
    indices = hungarian_match(pred_logits, pred_boxes, targets)
    assert len(indices) == 2
    assert len(indices[0][0]) == 2  # 2 GT boxes matched
    assert len(indices[1][0]) == 1  # 1 GT box matched
    print("✓ test_batch_matching")


def test_box_conversions():
    """Box format conversions."""
    cxcywh = torch.tensor([[0.5, 0.5, 0.2, 0.4]])
    xyxy = box_cxcywh_to_xyxy(cxcywh)
    expected = torch.tensor([[0.4, 0.3, 0.6, 0.7]])
    assert torch.allclose(xyxy, expected, atol=1e-5), f"Got {xyxy}"

    safe = safe_boxes_xyxy(cxcywh)
    assert (safe >= 0).all() and (safe <= 1).all()
    print("✓ test_box_conversions")


if __name__ == "__main__":
    test_basic_matching()
    test_empty_gt()
    test_batch_matching()
    test_box_conversions()
    print("\nAll matcher tests passed!")
