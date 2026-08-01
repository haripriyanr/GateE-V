"""VegaTaskAwareRTDETR: top-level GatE-V model.

Enhancements over STAGE1:
  - Multi-level FGTQGate (P3+P4+P5 instead of P5-only)
  - Task bias injected at every decoder layer (not just initial)
  - Discrete sampling as default cross-attention method
"""
from __future__ import annotations

import torch
import torch.nn as nn

from src.model.backbone import PResNet
from src.model.encoder import HybridEncoder
from src.model.decoder import RTDETRTransformerv2
from src.model.gate import MultilevelFGTQGate


class VegaTaskAwareRTDETR(nn.Module):
    def __init__(
        self,
        num_tasks: int = 14,
        num_queries: int = 300,
        hidden_dim: int = 256,
        num_encoder_layers: int = 1,
        num_decoder_layers: int = 6,
        eval_idx: int = 3,
        task_embed_dim: int = 128,
        fgtq_layers: list[str] | None = None,
        cross_attn_method: str = "discrete",
        use_learnable_residuals: bool = True,
        inject_task_every_layer: bool = True,
    ) -> None:
        super().__init__()
        self.hidden_dim = hidden_dim
        self.num_queries = num_queries
        self.inject_task_every_layer = inject_task_every_layer

        fgtq_layers = fgtq_layers or ["P3", "P4", "P5"]
        self.fgtq_layer_names = fgtq_layers

        # Backbone: PResNet-50 variant d
        self.backbone = PResNet(
            depth=50, variant="d", num_stages=4,
            return_idx=[1, 2, 3], act="relu",
            freeze_at=0, freeze_norm=True, pretrained=False,
        )

        # Multi-level task gate
        level_channels = {}
        channel_map = {"P3": 512, "P4": 1024, "P5": 2048}
        for lvl in fgtq_layers:
            level_channels[lvl] = channel_map[lvl]
        self.fgtq_gate = MultilevelFGTQGate(
            num_tasks=num_tasks,
            embed_dim=task_embed_dim,
            level_channels=level_channels,
            use_learnable_residuals=use_learnable_residuals,
        )

        # Encoder
        self.encoder = HybridEncoder(
            in_channels=[512, 1024, 2048],
            feat_strides=[8, 16, 32],
            hidden_dim=hidden_dim, nhead=8,
            dim_feedforward=1024, dropout=0.0,
            enc_act="gelu", use_encoder_idx=[2],
            num_encoder_layers=num_encoder_layers,
            expansion=0.5, depth_mult=1.0, act="silu",
        )

        # Decoder
        self.decoder = RTDETRTransformerv2(
            num_classes=1, hidden_dim=hidden_dim,
            num_queries=num_queries,
            feat_channels=[hidden_dim] * 3,
            feat_strides=[8, 16, 32],
            num_levels=3, num_points=[4, 4, 4],
            nhead=8, num_layers=num_decoder_layers,
            dim_feedforward=1024, dropout=0.0,
            activation="relu", num_denoising=0,
            eval_idx=eval_idx,
            cross_attn_method=cross_attn_method,
            query_select_method="agnostic",
        )

        # Task classification head
        self.task_head = nn.Linear(hidden_dim, num_tasks)
        # Task → query bias (for initial injection)
        self.task_to_query_bias = nn.Linear(task_embed_dim, hidden_dim)
        # Task → per-layer bias (for every-layer injection)
        if inject_task_every_layer:
            self.task_to_layer_bias = nn.Linear(task_embed_dim, hidden_dim)
            nn.init.zeros_(self.task_to_layer_bias.weight)
            nn.init.zeros_(self.task_to_layer_bias.bias)

        # Existence Head: predicts if ANY target exists for the task
        # Uses decoder hidden states (after 6 layers of refinement) instead of
        # raw encoder features for a much richer signal.
        self.exist_proj = nn.Linear(hidden_dim + task_embed_dim, hidden_dim)
        self.exist_pred = nn.Linear(hidden_dim, 1)

        self._init_heads()

    def _init_heads(self):
        nn.init.xavier_uniform_(self.task_to_query_bias.weight)
        nn.init.zeros_(self.task_to_query_bias.bias)
        nn.init.xavier_uniform_(self.task_head.weight)
        nn.init.zeros_(self.task_head.bias)
        nn.init.xavier_uniform_(self.exist_proj.weight)
        nn.init.zeros_(self.exist_proj.bias)
        nn.init.xavier_uniform_(self.exist_pred.weight)
        nn.init.zeros_(self.exist_pred.bias)

    def forward(self, images, task_ids):
        B = images.size(0)
        # Backbone
        p3, p4, p5 = self.backbone(images)

        # Multi-level FGTQGate (spec: P3+P4+P5)
        feats = [p3, p4, p5]
        level_names = ["P3", "P4", "P5"]
        # Only gate the configured levels
        gated = []
        for feat, name in zip(feats, level_names):
            if name in self.fgtq_layer_names:
                gated.append(
                    self.fgtq_gate.forward_level(feat, task_ids, name))
            else:
                gated.append(feat)

        # Encoder
        enc_feats = self.encoder(gated)

        # Task embeddings for decoder
        task_emb = self.fgtq_gate.get_task_embed(task_ids)
        query_bias = self.task_to_query_bias(task_emb)

        # Per-layer task bias (spec: inject at every decoder layer)
        layer_bias = None
        if self.inject_task_every_layer and hasattr(self, "task_to_layer_bias"):
            layer_bias = self.task_to_layer_bias(task_emb)

        # Decoder
        out, dec_hs = self.decoder(
            enc_feats,
            task_query_bias=query_bias,
            task_bias_per_layer=layer_bias,
        )

        pred_logits = out["pred_logits"]
        pred_boxes = out["pred_boxes"]
        task_logits = self.task_head(dec_hs)

        # Existence Prediction — uses decoder hidden states (much richer than encoder)
        # Mean-pool over all queries to get a global scene representation
        pooled_dec = dec_hs.mean(dim=1)                       # [B, hidden_dim]
        exist_feat = torch.cat([pooled_dec, task_emb], dim=1)  # [B, hidden_dim + task_embed_dim]
        exist_feat = torch.relu(self.exist_proj(exist_feat))
        exist_logits = self.exist_pred(exist_feat)             # [B, 1]

        return pred_logits, pred_boxes, task_logits, exist_logits

    def load_pretrained_partial(self, ckpt_path: str) -> None:
        """Load RT-DETRv2 pretrained weights, skipping custom heads."""
        print(f"[model] Loading weights from {ckpt_path}")
        # NOTE: weights_only=False is a potential security concern if the checkpoint source is untrusted.
        raw = torch.load(ckpt_path, map_location="cpu", weights_only=False)
        if isinstance(raw, dict):
            if "ema" in raw and isinstance(raw["ema"], dict):
                ema = raw["ema"]
                raw = ema.get("module", ema)
            elif "model" in raw and isinstance(raw["model"], dict):
                raw = raw["model"]
            elif "state_dict" in raw and isinstance(raw["state_dict"], dict):
                raw = raw["state_dict"]
        skip_keywords = (
            "task_head", "fgtq_gate", "fgtq",
            "task_to_query_bias", "task_to_layer_bias",
            "denoising_class_embed", "task_residual",
            "exist_",
        )
        own_state = self.state_dict()
        loaded, skipped = 0, 0
        for ckpt_key, param in raw.items():
            if any(kw in ckpt_key for kw in skip_keywords):
                skipped += 1
                continue
            if ckpt_key in own_state and own_state[ckpt_key].shape == param.shape:
                own_state[ckpt_key].copy_(param)
                loaded += 1
        self.load_state_dict(own_state)
        total_own = len(own_state)
        kept = total_own - loaded
        print(f"[model] Loaded {loaded}/{total_own} parameter tensors")
        print(f"[model] Skipped {skipped} custom-head keys")
        print(f"[model] {kept} parameters kept at random init (new heads)")
