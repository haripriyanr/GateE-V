"""HybridEncoder: intra-scale transformer + CSPRepLayer FPN/PAN.

Extracted verbatim from the monolithic main.py — no modifications.
"""
from __future__ import annotations

import copy
from collections import OrderedDict

import torch
import torch.nn as nn
import torch.nn.functional as F

from src.model.backbone import ConvNormLayer, get_activation


# ── RepVGG + CSP blocks ──────────────────────────────────────────────────


class RepVggBlock(nn.Module):
    def __init__(self, ch_in: int, ch_out: int, act: str = "relu") -> None:
        super().__init__()
        self.ch_in = ch_in
        self.ch_out = ch_out
        self.conv1 = ConvNormLayer(ch_in, ch_out, 3, 1, padding=1, act=None)
        self.conv2 = ConvNormLayer(ch_in, ch_out, 1, 1, padding=0, act=None)
        self.act = get_activation(act)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        if hasattr(self, "conv"):
            y = self.conv(x)
        else:
            y = self.conv1(x) + self.conv2(x)
        return self.act(y)


class CSPRepLayer(nn.Module):
    def __init__(
        self,
        in_channels: int,
        out_channels: int,
        num_blocks: int = 3,
        expansion: float = 1.0,
        bias=None,
        act: str = "silu",
    ) -> None:
        super().__init__()
        hidden_channels = int(out_channels * expansion)
        self.conv1 = ConvNormLayer(
            in_channels, hidden_channels, 1, 1, bias=bias, act=act
        )
        self.conv2 = ConvNormLayer(
            in_channels, hidden_channels, 1, 1, bias=bias, act=act
        )
        self.bottlenecks = nn.Sequential(
            *[
                RepVggBlock(hidden_channels, hidden_channels, act=act)
                for _ in range(num_blocks)
            ]
        )
        if hidden_channels != out_channels:
            self.conv3 = ConvNormLayer(
                hidden_channels, out_channels, 1, 1, bias=bias, act=act
            )
        else:
            self.conv3 = nn.Identity()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x_1 = self.bottlenecks(self.conv1(x))
        x_2 = self.conv2(x)
        return self.conv3(x_1 + x_2)


# ── Transformer encoder layers ───────────────────────────────────────────


class HybridEncoderLayer(nn.Module):
    """TransformerEncoderLayer with explicit positional embedding input.

    Named attributes match the upstream RT-DETRv2 checkpoint for
    direct state-dict key alignment.
    """

    def __init__(
        self,
        d_model: int,
        nhead: int,
        dim_feedforward: int = 2048,
        dropout: float = 0.0,
        activation: str = "gelu",
    ) -> None:
        super().__init__()
        self.self_attn = nn.MultiheadAttention(
            d_model, nhead, dropout, batch_first=True
        )
        self.linear1 = nn.Linear(d_model, dim_feedforward)
        self.dropout = nn.Dropout(dropout)
        self.linear2 = nn.Linear(dim_feedforward, d_model)
        self.norm1 = nn.LayerNorm(d_model)
        self.norm2 = nn.LayerNorm(d_model)
        self.dropout1 = nn.Dropout(dropout)
        self.dropout2 = nn.Dropout(dropout)
        self.activation = get_activation(activation)

    @staticmethod
    def with_pos_embed(tensor, pos_embed):
        return tensor if pos_embed is None else tensor + pos_embed

    def forward(self, src, src_mask=None, pos_embed=None):
        residual = src
        q = k = self.with_pos_embed(src, pos_embed)
        src, _ = self.self_attn(q, k, value=src, attn_mask=src_mask)
        src = residual + self.dropout1(src)
        src = self.norm1(src)
        residual = src
        src = self.linear2(self.dropout(self.activation(self.linear1(src))))
        src = residual + self.dropout2(src)
        src = self.norm2(src)
        return src


class HybridEncoderBlock(nn.Module):
    """TransformerEncoder wrapping multiple HybridEncoderLayers."""

    def __init__(self, encoder_layer, num_layers: int) -> None:
        super().__init__()
        self.layers = nn.ModuleList(
            [copy.deepcopy(encoder_layer) for _ in range(num_layers)]
        )
        self.num_layers = num_layers

    def forward(self, src, src_mask=None, pos_embed=None):
        output = src
        for layer in self.layers:
            output = layer(output, src_mask=src_mask, pos_embed=pos_embed)
        return output


# ── HybridEncoder ─────────────────────────────────────────────────────────


class HybridEncoder(nn.Module):
    """RT-DETRv2 HybridEncoder: intra-scale transformer + CSPRepLayer FPN/PAN.

    Config (M variant): expansion=0.5, depth_mult=1, use_encoder_idx=[2].
    """

    def __init__(
        self,
        in_channels: list[int] = [512, 1024, 2048],
        feat_strides: list[int] = [8, 16, 32],
        hidden_dim: int = 256,
        nhead: int = 8,
        dim_feedforward: int = 1024,
        dropout: float = 0.0,
        enc_act: str = "gelu",
        use_encoder_idx: list[int] = [2],
        num_encoder_layers: int = 1,
        pe_temperature: float = 10000.0,
        expansion: float = 0.5,
        depth_mult: float = 1.0,
        act: str = "silu",
    ) -> None:
        super().__init__()
        self.in_channels = in_channels
        self.feat_strides = feat_strides
        self.hidden_dim = hidden_dim
        self.use_encoder_idx = use_encoder_idx
        self.num_encoder_layers = num_encoder_layers
        self.pe_temperature = pe_temperature
        self.out_channels = [hidden_dim for _ in range(len(in_channels))]
        self.out_strides = feat_strides

        # Channel projection (backbone channels → hidden_dim)
        self.input_proj = nn.ModuleList()
        for in_channel in in_channels:
            self.input_proj.append(
                nn.Sequential(
                    OrderedDict(
                        [
                            (
                                "conv",
                                nn.Conv2d(
                                    in_channel,
                                    hidden_dim,
                                    kernel_size=1,
                                    bias=False,
                                ),
                            ),
                            ("norm", nn.BatchNorm2d(hidden_dim)),
                        ]
                    )
                )
            )

        # Intra-scale encoder transformer (applied to P5 only)
        encoder_layer = HybridEncoderLayer(
            hidden_dim,
            nhead=nhead,
            dim_feedforward=dim_feedforward,
            dropout=dropout,
            activation=enc_act,
        )
        self.encoder = nn.ModuleList(
            [
                HybridEncoderBlock(
                    copy.deepcopy(encoder_layer), num_encoder_layers
                )
                for _ in range(len(use_encoder_idx))
            ]
        )

        # Top-down FPN
        self.lateral_convs = nn.ModuleList()
        self.fpn_blocks = nn.ModuleList()
        for _ in range(len(in_channels) - 1, 0, -1):
            self.lateral_convs.append(
                ConvNormLayer(hidden_dim, hidden_dim, 1, 1, act=act)
            )
            self.fpn_blocks.append(
                CSPRepLayer(
                    hidden_dim * 2,
                    hidden_dim,
                    round(3 * depth_mult),
                    act=act,
                    expansion=expansion,
                )
            )

        # Bottom-up PAN
        self.downsample_convs = nn.ModuleList()
        self.pan_blocks = nn.ModuleList()
        for _ in range(len(in_channels) - 1):
            self.downsample_convs.append(
                ConvNormLayer(hidden_dim, hidden_dim, 3, 2, act=act)
            )
            self.pan_blocks.append(
                CSPRepLayer(
                    hidden_dim * 2,
                    hidden_dim,
                    round(3 * depth_mult),
                    act=act,
                    expansion=expansion,
                )
            )

    @staticmethod
    def build_2d_sincos_position_embedding(
        w: int,
        h: int,
        embed_dim: int = 256,
        temperature: float = 10000.0,
    ) -> torch.Tensor:
        grid_w = torch.arange(int(w), dtype=torch.float32)
        grid_h = torch.arange(int(h), dtype=torch.float32)
        grid_w, grid_h = torch.meshgrid(grid_w, grid_h, indexing="ij")
        pos_dim = embed_dim // 4
        omega = torch.arange(pos_dim, dtype=torch.float32) / pos_dim
        omega = 1.0 / (temperature**omega)
        out_w = grid_w.flatten()[..., None] @ omega[None]
        out_h = grid_h.flatten()[..., None] @ omega[None]
        return torch.concat(
            [out_w.sin(), out_w.cos(), out_h.sin(), out_h.cos()], dim=1
        )[None, :, :]

    def forward(self, feats: list[torch.Tensor]) -> list[torch.Tensor]:
        assert len(feats) == len(self.in_channels)
        proj_feats = [self.input_proj[i](feat) for i, feat in enumerate(feats)]

        # Intra-scale encoder (applied to P5 only per use_encoder_idx=[2])
        if self.num_encoder_layers > 0:
            for i, enc_ind in enumerate(self.use_encoder_idx):
                h, w = proj_feats[enc_ind].shape[2:]
                src_flatten = proj_feats[enc_ind].flatten(2).permute(0, 2, 1)
                pos_embed = self.build_2d_sincos_position_embedding(
                    w, h, self.hidden_dim, self.pe_temperature
                ).to(src_flatten.device)
                memory = self.encoder[i](src_flatten, pos_embed=pos_embed)
                proj_feats[enc_ind] = (
                    memory.permute(0, 2, 1)
                    .reshape(-1, self.hidden_dim, h, w)
                    .contiguous()
                )

        # Top-down FPN
        inner_outs = [proj_feats[-1]]
        for idx in range(len(self.in_channels) - 1, 0, -1):
            feat_high = inner_outs[0]
            feat_low = proj_feats[idx - 1]
            feat_high = self.lateral_convs[len(self.in_channels) - 1 - idx](
                feat_high
            )
            inner_outs[0] = feat_high
            upsample_feat = F.interpolate(
                feat_high, scale_factor=2.0, mode="nearest"
            )
            inner_out = self.fpn_blocks[len(self.in_channels) - 1 - idx](
                torch.concat([upsample_feat, feat_low], dim=1)
            )
            inner_outs.insert(0, inner_out)

        # Bottom-up PAN
        outs = [inner_outs[0]]
        for idx in range(len(self.in_channels) - 1):
            feat_low = outs[-1]
            feat_height = inner_outs[idx + 1]
            downsample_feat = self.downsample_convs[idx](feat_low)
            out = self.pan_blocks[idx](
                torch.concat([downsample_feat, feat_height], dim=1)
            )
            outs.append(out)

        return outs
