"""FGTQGate: Fine-Grained Task-Query Gate with CLIP semantic seeding.

Enhancements over STAGE1:
  - MultilevelFGTQGate: applies task-conditioning to P3, P4, P5 (was P5-only)
  - Learnable task residuals: 14×128 params on top of CLIP embeddings
  - Pre-compute CLIP embeddings utility
"""
from __future__ import annotations

from pathlib import Path

import torch
import torch.nn as nn
import torch.nn.functional as F


TASK_DESCRIPTIONS = [
    "step on something to reach the top of a shelf",
    "sit comfortably",
    "place flowers in a container",
    "get potatoes out of fire",
    "water a plant",
    "get a lemon out of tea",
    "dig a hole",
    "open a bottle of beer",
    "open a parcel",
    "serve wine in a glass",
    "pour sugar",
    "smear butter on bread",
    "extinguish a fire",
    "pound a carpet",
]


# ── Single-level gate (backward-compatible with STAGE1) ──────────────────


class FGTQGate(nn.Module):
    """Single-level FGTQGate (P5 only). Kept for backward compatibility."""

    def __init__(self, num_tasks=14, embed_dim=128, feature_channels=2048):
        super().__init__()
        self.task_embedding = nn.Embedding(num_tasks, embed_dim)
        self.gamma_proj = nn.Linear(embed_dim, feature_channels)
        self.beta_proj = nn.Linear(embed_dim, feature_channels)
        nn.init.zeros_(self.gamma_proj.weight)
        nn.init.ones_(self.gamma_proj.bias)
        nn.init.zeros_(self.beta_proj.weight)
        nn.init.zeros_(self.beta_proj.bias)

    def forward(self, p5, task_ids):
        emb = self.task_embedding(task_ids)
        gamma = self.gamma_proj(emb).unsqueeze(-1).unsqueeze(-1)
        beta = self.beta_proj(emb).unsqueeze(-1).unsqueeze(-1)
        return p5 * gamma + beta


# ── Multi-level gate (spec improvement) ──────────────────────────────────


class MultilevelFGTQGate(nn.Module):
    """Task-conditioning gate applied to P3, P4, P5 backbone outputs.

    Each level gets its own gamma/beta projections sized to match the
    backbone channel dimension at that level (512, 1024, 2048 for R50).

    Includes learnable task residuals (14×128) on top of CLIP embeddings.
    """

    # RepVGG-B0 backbone output channels for stages [1, 2, 3] (return_idx)
    DEFAULT_CHANNELS = {"P3": 128, "P4": 256, "P5": 1280}

    def __init__(
        self,
        num_tasks: int = 14,
        embed_dim: int = 128,
        level_channels: dict[str, int] | None = None,
        use_learnable_residuals: bool = True,
    ):
        super().__init__()
        self.num_tasks = num_tasks
        self.embed_dim = embed_dim
        channels = level_channels or self.DEFAULT_CHANNELS

        # Shared task embedding (CLIP-seeded)
        self.task_embedding = nn.Embedding(num_tasks, embed_dim)

        # Learnable residual on top of CLIP embeddings (initialized to zero)
        self.use_learnable_residuals = use_learnable_residuals
        if use_learnable_residuals:
            self.task_residual = nn.Parameter(
                torch.zeros(num_tasks, embed_dim)
            )

        # Per-level gamma/beta projections
        self.level_names = sorted(channels.keys())
        self.gamma_projs = nn.ModuleDict()
        self.beta_projs = nn.ModuleDict()
        for name in self.level_names:
            ch = channels[name]
            gamma = nn.Linear(embed_dim, ch)
            beta = nn.Linear(embed_dim, ch)
            # Init: gamma → 1 (identity), beta → 0 (no shift)
            nn.init.zeros_(gamma.weight)
            nn.init.ones_(gamma.bias)
            nn.init.zeros_(beta.weight)
            nn.init.zeros_(beta.bias)
            self.gamma_projs[name] = gamma
            self.beta_projs[name] = beta

    def get_task_embed(self, task_ids: torch.Tensor) -> torch.Tensor:
        """Get task embedding with optional learnable residual."""
        emb = self.task_embedding(task_ids)
        if self.use_learnable_residuals:
            emb = emb + self.task_residual[task_ids]
        return emb

    def forward_level(
        self, feat: torch.Tensor, task_ids: torch.Tensor, level: str,
        cached_embed: torch.Tensor | None = None,
    ) -> torch.Tensor:
        """Apply gate to a single feature level."""
        emb = cached_embed if cached_embed is not None else self.get_task_embed(task_ids)
        gamma = self.gamma_projs[level](emb).unsqueeze(-1).unsqueeze(-1)
        beta = self.beta_projs[level](emb).unsqueeze(-1).unsqueeze(-1)
        return feat * gamma + beta

    def forward(
        self,
        features: list[torch.Tensor],
        task_ids: torch.Tensor,
        levels: list[str] | None = None,
    ) -> list[torch.Tensor]:
        """Apply gate to multiple feature levels."""
        levels = levels or self.level_names
        assert len(features) == len(levels), (
            f"Expected {len(levels)} features, got {len(features)}"
        )
        emb = self.get_task_embed(task_ids)
        return [
            self.forward_level(feat, task_ids, lvl, cached_embed=emb)
            for feat, lvl in zip(features, levels)
        ]


# ── CLIP semantic seeding ────────────────────────────────────────────────


PROMPT_TEMPLATES = [
    "{}",
    "a photo of an object used to {}",
    "a clear image showing something to {}",
    "find an object that helps you {}",
]


def get_task_semantic_seeding(dim: int = 128, use_ensemble: bool = True) -> torch.Tensor | None:
    """Generate CLIP-seeded task embeddings via JL projection (with multi-prompt ensembling).

    Returns (14, dim) tensor or None if CLIP unavailable.
    """
    try:
        import clip
    except ImportError:
        print(
            "[model] 'clip' not found. pip install git+https://github.com/openai/CLIP.git"
        )
        print("[model] Semantic seeding will be SKIPPED.")
        return None

    print("[model] Generating CLIP semantic task embeddings (multi-prompt ensembling)...")
    clip_model, _ = clip.load("ViT-B/32", device="cpu")
    clip_model.eval()

    all_features = []
    with torch.no_grad():
        if use_ensemble:
            for template in PROMPT_TEMPLATES:
                prompts = [template.format(desc) for desc in TASK_DESCRIPTIONS]
                tokens = clip.tokenize(prompts)
                feat = clip_model.encode_text(tokens).float()
                feat = F.normalize(feat, dim=-1)
                all_features.append(feat)
            features = torch.stack(all_features, dim=0).mean(dim=0)
        else:
            tokens = clip.tokenize(TASK_DESCRIPTIONS)
            features = clip_model.encode_text(tokens).float()

    # L2-normalise onto the unit hypersphere
    features = F.normalize(features, dim=-1)  # [14, 512]

    # JL random-orthonormal projection (512 → dim)
    gen = torch.Generator().manual_seed(42)
    proj = torch.randn(features.shape[1], dim, generator=gen)
    proj, _ = torch.linalg.qr(proj)
    projected = features @ proj  # [14, dim]
    projected = F.normalize(projected, dim=-1)

    return projected


def load_precomputed_embeddings(
    path: str | Path, dim: int = 128
) -> torch.Tensor | None:
    """Load pre-computed CLIP embeddings from a .pt file."""
    path = Path(path)
    if not path.exists():
        print(f"[model] Pre-computed embeddings not found at {path}")
        return None
    embeddings = torch.load(path, map_location="cpu", weights_only=True)
    if embeddings.shape[-1] != dim:
        print(f"[model] Warning: embedding dim {embeddings.shape[-1]} != {dim}")
    return embeddings


def apply_semantic_seeding(
    gate: MultilevelFGTQGate | FGTQGate,
    precomputed_path: str | Path | None = None,
    dim: int = 128,
) -> None:
    """Seed gate's task embeddings from CLIP or pre-computed file."""
    print("[model] Seeding FGTQ task embeddings from CLIP semantic descriptions...")

    if precomputed_path:
        sem_matrix = load_precomputed_embeddings(precomputed_path, dim)
    else:
        sem_matrix = get_task_semantic_seeding(dim=dim)

    if sem_matrix is not None:
        with torch.no_grad():
            gate.task_embedding.weight.copy_(sem_matrix)
        print("[model] Semantic seeding applied successfully.")
    else:
        print("[model] Semantic seeding skipped — using random init.")


def precompute_clip_embeddings(output_path: str | Path) -> None:
    """Pre-compute CLIP task embeddings and save to .pt file."""
    try:
        import clip
    except ImportError:
        raise ImportError(
            "CLIP is required. Install: pip install git+https://github.com/openai/CLIP.git"
        )

    print("[clip] Loading ViT-B/32...")
    model, _ = clip.load("ViT-B/32", device="cpu")
    model.eval()

    with torch.no_grad():
        tokens = clip.tokenize(TASK_DESCRIPTIONS)
        features = model.encode_text(tokens).float()

    features = F.normalize(features, dim=-1)
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    torch.save(features, output_path)
    print(f"[clip] Saved {features.shape} embeddings → {output_path}")
