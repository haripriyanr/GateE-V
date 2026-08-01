"""GatEVTaskAwareRTDETR: top-level GatE-V model.

Enhancements over STAGE1:
  - Multi-level FGTQGate (P3+P4+P5 instead of P5-only)
  - Task bias injected at every decoder layer (not just initial)
  - Discrete sampling as default cross-attention method
  - CNN aux branch: lightweight conv heads on encoder outputs (training-only)
  - Self-KD via EMA teacher: soft targets from exponential moving average
"""
from __future__ import annotations

import copy
import torch
import torch.nn as nn
import timm

from src.model.encoder import HybridEncoder
from src.model.decoder import RTDETRTransformerv2
from src.model.gate import MultilevelFGTQGate


class AuxCNNHead(nn.Module):
    """Lightweight CNN detection head on encoder feature maps (training-only).
    
    Applied to P3/P4/P5 encoder outputs. Predicts class logits and boxes
    in dense grid format. Loss computed via Hungarian matching.
    Discarded before weight export — zero inference cost."""

    def __init__(self, hidden_dim: int = 256):
        super().__init__()
        self.conv = nn.Conv2d(hidden_dim, hidden_dim, 3, padding=1)
        self.norm = nn.GroupNorm(32, hidden_dim)
        self.act = nn.ReLU(inplace=True)
        self.cls_head = nn.Conv2d(hidden_dim, 1, 1)
        self.box_head = nn.Conv2d(hidden_dim, 4, 1)
        self._init_weights()

    def _init_weights(self):
        for m in [self.conv, self.cls_head, self.box_head]:
            nn.init.xavier_uniform_(m.weight)
            if m.bias is not None:
                nn.init.zeros_(m.bias)

    def forward(self, x: torch.Tensor) -> tuple[torch.Tensor, torch.Tensor]:
        feat = self.act(self.norm(self.conv(x)))
        cls_logits = self.cls_head(feat).flatten(2).permute(0, 2, 1)
        boxes = self.box_head(feat).flatten(2).permute(0, 2, 1).sigmoid()
        return cls_logits, boxes


class GatEVTaskAwareRTDETR(nn.Module):
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
        backbone_name: str = "hgnetv2_b1",
        backbone_pretrained: bool = False,
        use_checkpoint: bool = False,
        use_fgpa: bool = False,
        use_aff: bool = False,
        use_aux_head: bool = False,
        use_kd: bool = False,
        kd_decay: float = 0.999,
    ) -> None:
        super().__init__()
        self.hidden_dim = hidden_dim
        self.num_queries = num_queries
        self.inject_task_every_layer = inject_task_every_layer
        self.use_checkpoint = use_checkpoint
        self.use_fgpa = use_fgpa
        self.use_aff = use_aff
        self.use_aux_head = use_aux_head
        self.use_kd = use_kd

        fgtq_layers = fgtq_layers or ["P3", "P4", "P5"]
        self.fgtq_layer_names = fgtq_layers
        if backbone_name == "r50vd":
            from src.model.backbone import PResNet
            # FGPA: add P2 (stride 4) for fine-grained features
            ret_idx = [0, 1, 2, 3] if self.use_fgpa else [1, 2, 3]
            self.backbone = PResNet(
                depth=50, variant="d", num_stages=4,
                return_idx=ret_idx, act="relu",
                freeze_at=0, freeze_norm=True, pretrained=backbone_pretrained,
            )
            if self.use_fgpa:
                level_channels = {"P2": 256, "P3": 512, "P4": 1024, "P5": 2048}
            else:
                level_channels = {"P3": 512, "P4": 1024, "P5": 2048}
            print(f"[detector] Backbone: PResNet-50vd ({'pretrained' if backbone_pretrained else 'from scratch'})")
        else:
            # Dynamic backbone initialization targeting strides 8, 16, 32 (P3, P4, P5)
            # If use_fgpa is enabled, we also need stride 4 (P2)
            self.backbone = timm.create_model(
                backbone_name,
                pretrained=backbone_pretrained,
                features_only=True
            )
            target_strides = [4, 8, 16, 32] if self.use_fgpa else [8, 16, 32]
            valid_indices = []
            for i, info in enumerate(self.backbone.feature_info):
                if info['reduction'] in target_strides:
                    valid_indices.append(i)
                    
            if len(valid_indices) != len(target_strides):
                raise ValueError(f"Backbone {backbone_name} does not support strides {target_strides}. Found: {[i['reduction'] for i in self.backbone.feature_info]}")
                
            # Recreate with exact out_indices
            self.backbone = timm.create_model(
                backbone_name,
                pretrained=backbone_pretrained,
                features_only=True,
                out_indices=valid_indices
            )
            print(f"[detector] Backbone: {backbone_name} ({'pretrained' if backbone_pretrained else 'from scratch'})")

            # Multi-level task gate dynamically configures channel sizes
            level_channels = {}
            levels = ["P2", "P3", "P4", "P5"] if self.use_fgpa else ["P3", "P4", "P5"]
            for idx, lvl in enumerate(levels):
                if lvl in fgtq_layers:
                    level_channels[lvl] = self.backbone.feature_info[valid_indices[idx]]['num_chs']

        self.fgtq_gate = MultilevelFGTQGate(
            num_tasks=num_tasks,
            embed_dim=task_embed_dim,
            level_channels=level_channels,
            use_learnable_residuals=use_learnable_residuals,
        )

        # Encoder/decoder always at 3 levels (P3-P5) for pretrained checkpoint
        # compatibility. P2 may exist in level_channels (FGTQGate projections)
        # but must never reach the encoder's input_proj / FPN / PAN or the
        # decoder's cross-attention levels — doing so reshapes ~200 parameter
        # tensors away from the checkpoint, leaving them randomly initialized.
        encoder_levels = [n for n in ["P3", "P4", "P5"] if n in level_channels]
        enc_in_channels = [level_channels[n] for n in encoder_levels]
        enc_strides = [{"P3": 8, "P4": 16, "P5": 32}[n] for n in encoder_levels]
        # Encoder
        self.encoder = HybridEncoder(
            in_channels=enc_in_channels,
            feat_strides=enc_strides,
            hidden_dim=hidden_dim, nhead=8,
            dim_feedforward=1024, dropout=0.0,
            enc_act="gelu",
            use_encoder_idx=[len(encoder_levels) - 1],  # apply to highest level
            num_encoder_layers=num_encoder_layers,
            expansion=0.5, depth_mult=1.0, act="silu",
            use_fgpa=use_fgpa,
            use_aff=use_aff,
        )

        # Decoder
        num_feat_levels = len(encoder_levels)
        self.decoder = RTDETRTransformerv2(
            num_classes=1, hidden_dim=hidden_dim,
            num_queries=num_queries,
            feat_channels=[hidden_dim] * num_feat_levels,
            feat_strides=enc_strides,
            num_levels=num_feat_levels, num_points=[4] * num_feat_levels,
            nhead=8, num_layers=num_decoder_layers,
            dim_feedforward=1024, dropout=0.0,
            activation="relu", num_denoising=0,
            eval_idx=eval_idx,
            cross_attn_method=cross_attn_method,
            query_select_method="agnostic",
            use_checkpoint=self.use_checkpoint,
        )

        # Task classification head
        self.task_head = nn.Linear(hidden_dim, num_tasks)
        # Task → query bias (initial injection into decoder queries)
        self.task_to_query_bias = nn.Linear(task_embed_dim, hidden_dim)
        if inject_task_every_layer:
            self.task_to_layer_bias = nn.Linear(task_embed_dim, hidden_dim)
            nn.init.zeros_(self.task_to_layer_bias.weight)
            nn.init.zeros_(self.task_to_layer_bias.bias)

        # Existence Head: predicts if ANY target exists for the task
        # Uses decoder hidden states (after 6 layers of refinement) instead of
        # raw encoder features for a much richer signal.
        self.exist_proj = nn.Linear(hidden_dim + task_embed_dim, hidden_dim)
        self.exist_pred = nn.Linear(hidden_dim, 1)

        # CNN aux branch: lightweight heads on encoder outputs (training-only)
        if use_aux_head:
            num_feat_levels = len(encoder_levels)
            self.aux_heads = nn.ModuleList([
                AuxCNNHead(hidden_dim) for _ in range(num_feat_levels)
            ])
            self.aux_feat_strides = enc_strides

        # EMA teacher for self-KD
        if use_kd:
            self.kd_decay = kd_decay
            self._teacher_ref = []  # empty = no teacher yet

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
        # Backbone (returns 3 or 4 levels depending on FGPA)
        if self.use_fgpa:
            p2, p3, p4, p5 = self.backbone(images)
            feats = [p2, p3, p4, p5]
            level_names = ["P2", "P3", "P4", "P5"]
        else:
            p3, p4, p5 = self.backbone(images)
            feats = [p3, p4, p5]
            level_names = ["P3", "P4", "P5"]
        # Compute task_embed ONCE and cache
        task_emb = self.fgtq_gate.get_task_embed(task_ids)
        gated = []
        for feat, name in zip(feats, level_names):
            if name in self.fgtq_layer_names:
                gated.append(
                    self.fgtq_gate.forward_level(feat, task_ids, name, cached_embed=task_emb))
            else:
                gated.append(feat)

        # Only P3-P5 go to the encoder/decoder, preserving pretrained-checkpoint
        # 3-level compatibility. P2 (if FGPA enabled) is gated and stashed here,
        # currently unused downstream — it does NOT yet receive gradient.
        # NOTE: .detach() is essential — non-leaf tensors break ModelEMA's
        # copy.deepcopy, which is called after the forward+backward pass in
        # _ensure_batch_fits during training setup.
        self.p2_gated = gated[0].detach() if self.use_fgpa else None
        enc_input = gated[1:] if self.use_fgpa else gated

        # Encoder
        enc_feats = self.encoder(enc_input, use_checkpoint=self.use_checkpoint)

        # Task embeddings for decoder
        query_bias = self.task_to_query_bias(task_emb)

        layer_bias = None
        if self.inject_task_every_layer and hasattr(self, "task_to_layer_bias"):
            layer_bias = self.task_to_layer_bias(task_emb)

        # Decoder with stable additive task bias, matching the working v2 path.
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

        aux_outputs = out.get("aux_outputs")
        enc_outputs = out.get("enc_outputs")

        # CNN aux branch: dense predictions on encoder outputs (training-only)
        aux_preds = None
        if self.use_aux_head and self.training:
            aux_preds = []
            for i, (feat, stride) in enumerate(zip(enc_feats, self.aux_feat_strides)):
                if i < len(self.aux_heads):
                    cls, box = self.aux_heads[i](feat)
                    aux_preds.append({"cls": cls, "box": box, "stride": stride})

        return pred_logits, pred_boxes, task_logits, exist_logits, aux_outputs, enc_outputs, aux_preds

    def load_pretrained_partial(self, ckpt_path: str | None = None) -> None:
        """Load pretrained weights. HGNetV2 backbone already has ImageNet weights
        from timm, and RT-DETRv2 checkpoint compatibility is partial, so
        this is a no-op unless a custom checkpoint is provided."""
        if ckpt_path is None:
            print(f"[model] Backbone initialized via timm")
            print("[model] Detection heads initialized from scratch")
            return
        print(f"[model] Loading custom weights from {ckpt_path}")
        raw = torch.load(ckpt_path, map_location="cpu", weights_only=False)
        if isinstance(raw, dict):
            if "ema" in raw and isinstance(raw["ema"], dict):
                raw = raw["ema"].get("module", raw["ema"])
            elif "model" in raw and isinstance(raw["model"], dict):
                raw = raw["model"]
            elif "state_dict" in raw and isinstance(raw["state_dict"], dict):
                raw = raw["state_dict"]
        skip_keywords = (
            "task_head", "fgtq_gate", "fgtq",
            "task_to_query_bias", "task_to_layer_bias",
            "denoising_class_embed", "task_residual",
            "exist_", "aux_head",
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
        total_own = len(own_state)
        kept = total_own - loaded
        print(f"[model] Loaded {loaded}/{total_own} parameter tensors")
        print(f"[model] Skipped {skipped} custom-head keys")
        print(f"[model] {kept} parameters kept at random init (new heads)")

    def create_teacher(self, device: torch.device) -> None:
        """Create a copy of the student model for EMA self-distillation.
        Uses a plain dict to avoid double-counting teacher params in state_dict."""
        if not self.use_kd:
            return
        teacher = copy.deepcopy(self)
        teacher.to(device)
        for p in teacher.parameters():
            p.requires_grad = False
        teacher.eval()
        # Store as list so PyTorch doesn't register teacher as submodule
        # (otherwise state_dict saves 2x params)
        self._teacher_ref = [teacher]
        print(f"[model] EMA teacher created ({sum(p.numel() for p in teacher.parameters()):,} params)")

    @property
    def teacher(self) -> nn.Module | None:
        return self._teacher_ref[0] if hasattr(self, "_teacher_ref") else None

    def update_teacher(self) -> None:
        """EMA update: teacher ← decay * teacher + (1 - decay) * student."""
        t = self.teacher
        if not self.use_kd or t is None:
            return
        with torch.no_grad():
            for tp, sp in zip(t.parameters(), self.parameters()):
                tp.data.mul_(self.kd_decay).add_(sp.data, alpha=1.0 - self.kd_decay)

    def sync_teacher(self) -> None:
        """Sync teacher weights with current student weights (used after resume)."""
        t = self.teacher
        if not self.use_kd or t is None:
            return
        with torch.no_grad():
            for tp, sp in zip(t.parameters(), self.parameters()):
                tp.data.copy_(sp.data)
