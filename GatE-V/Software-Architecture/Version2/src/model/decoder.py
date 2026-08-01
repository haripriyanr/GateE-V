"""RTDETRv2 decoder with multi-scale deformable attention.

Extracted from monolithic main.py. Enhanced: decoder now supports
per-layer task bias injection via the ``task_bias`` argument.
"""
from __future__ import annotations

import copy
import functools
import math
from collections import OrderedDict

import torch
import torch.nn as nn
import torch.nn.functional as F

from src.model.backbone import get_activation


def inverse_sigmoid(x: torch.Tensor, eps: float = 1e-5) -> torch.Tensor:
    x = x.clip(min=0.0, max=1.0)
    return torch.log(x.clip(min=eps) / (1 - x).clip(min=eps))


def bias_init_with_prob(prior_prob: float = 0.01) -> float:
    return float(-math.log((1 - prior_prob) / prior_prob))


def deformable_attention_core_func_v2(
    value, value_spatial_shapes, sampling_locations, attention_weights,
    num_points_list, method="default",
):
    bs, _, n_head, c = value.shape
    _, Len_q, _, _, _ = sampling_locations.shape
    split_shape = [h * w for h, w in value_spatial_shapes]
    value_list = value.permute(0, 2, 3, 1).flatten(0, 1).split(split_shape, dim=-1)
    if method == "default":
        sampling_grids = 2 * sampling_locations - 1
    elif method == "discrete":
        sampling_grids = sampling_locations
    else:
        raise ValueError(f"Unknown method: {method}")
    sampling_grids = sampling_grids.permute(0, 2, 1, 3, 4).flatten(0, 1)
    sampling_locations_list = sampling_grids.split(num_points_list, dim=-2)
    sampling_value_list = []
    for level, (h, w) in enumerate(value_spatial_shapes):
        value_l = value_list[level].reshape(bs * n_head, c, h, w)
        sampling_grid_l = sampling_locations_list[level]
        if method == "default":
            sampling_value_l = F.grid_sample(
                value_l, sampling_grid_l, mode="bilinear",
                padding_mode="zeros", align_corners=False,
            )
        elif method == "discrete":
            sampling_coord = (
                sampling_grid_l * torch.tensor([[w, h]], device=value.device) + 0.5
            ).to(torch.int64)
            sampling_coord[..., 0].clamp_(0, w - 1)
            sampling_coord[..., 1].clamp_(0, h - 1)
            sampling_coord = sampling_coord.reshape(
                bs * n_head, Len_q * num_points_list[level], 2
            )
            s_idx = (
                torch.arange(sampling_coord.shape[0], device=value.device)
                .unsqueeze(-1).repeat(1, sampling_coord.shape[1])
            )
            sampling_value_l = value_l[
                s_idx, :, sampling_coord[..., 1], sampling_coord[..., 0]
            ]
            sampling_value_l = sampling_value_l.permute(0, 2, 1).reshape(
                bs * n_head, c, Len_q, num_points_list[level]
            )
        sampling_value_list.append(sampling_value_l)
    attn_weights = attention_weights.permute(0, 2, 1, 3).reshape(
        bs * n_head, 1, Len_q, sum(num_points_list)
    )
    weighted = torch.concat(sampling_value_list, dim=-1) * attn_weights
    output = weighted.sum(-1).reshape(bs, n_head * c, Len_q)
    return output.permute(0, 2, 1)


class MLP(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim, num_layers, act="relu"):
        super().__init__()
        self.num_layers = num_layers
        h = [hidden_dim] * (num_layers - 1)
        self.layers = nn.ModuleList(
            nn.Linear(n, k) for n, k in zip([input_dim] + h, h + [output_dim])
        )
        self.act = get_activation(act)

    def forward(self, x):
        for i, layer in enumerate(self.layers):
            x = self.act(layer(x)) if i < self.num_layers - 1 else layer(x)
        return x


class MSDeformableAttention(nn.Module):
    def __init__(self, embed_dim=256, num_heads=8, num_levels=3,
                 num_points=4, method="discrete", offset_scale=0.5):
        super().__init__()
        self.embed_dim = embed_dim
        self.num_heads = num_heads
        self.num_levels = num_levels
        self.offset_scale = offset_scale
        if isinstance(num_points, list):
            assert len(num_points) == num_levels
            num_points_list = num_points
        else:
            num_points_list = [num_points] * num_levels
        self.num_points_list = num_points_list
        num_points_scale = [1 / n for n in num_points_list for _ in range(n)]
        self.register_buffer("num_points_scale",
                             torch.tensor(num_points_scale, dtype=torch.float32))
        self.total_points = num_heads * sum(num_points_list)
        self.method = method
        self.head_dim = embed_dim // num_heads
        assert self.head_dim * num_heads == embed_dim
        self.sampling_offsets = nn.Linear(embed_dim, self.total_points * 2)
        self.attention_weights = nn.Linear(embed_dim, self.total_points)
        self.value_proj = nn.Linear(embed_dim, embed_dim)
        self.output_proj = nn.Linear(embed_dim, embed_dim)
        self.ms_deformable_attn_core = functools.partial(
            deformable_attention_core_func_v2, method=self.method)
        self._reset_parameters()
        if method == "discrete":
            for p in self.sampling_offsets.parameters():
                p.requires_grad = False

    def _reset_parameters(self):
        nn.init.constant_(self.sampling_offsets.weight, 0)
        thetas = torch.arange(self.num_heads, dtype=torch.float32) * (
            2.0 * math.pi / self.num_heads)
        grid_init = torch.stack([thetas.cos(), thetas.sin()], -1)
        grid_init = grid_init / grid_init.abs().max(-1, keepdim=True).values
        grid_init = grid_init.reshape(self.num_heads, 1, 2).tile(
            [1, sum(self.num_points_list), 1])
        scaling = torch.concat(
            [torch.arange(1, n + 1) for n in self.num_points_list]).reshape(1, -1, 1)
        grid_init *= scaling
        self.sampling_offsets.bias.data[...] = grid_init.flatten()
        nn.init.constant_(self.attention_weights.weight, 0)
        nn.init.constant_(self.attention_weights.bias, 0)
        nn.init.xavier_uniform_(self.value_proj.weight)
        nn.init.constant_(self.value_proj.bias, 0)
        nn.init.xavier_uniform_(self.output_proj.weight)
        nn.init.constant_(self.output_proj.bias, 0)

    def forward(self, query, reference_points, value,
                value_spatial_shapes, value_mask=None):
        bs, Len_q = query.shape[:2]
        Len_v = value.shape[1]
        value = self.value_proj(value)
        if value_mask is not None:
            value = value * value_mask.to(value.dtype).unsqueeze(-1)
        value = value.reshape(bs, Len_v, self.num_heads, self.head_dim)
        sampling_offsets = self.sampling_offsets(query).reshape(
            bs, Len_q, self.num_heads, sum(self.num_points_list), 2)
        attention_weights = self.attention_weights(query).reshape(
            bs, Len_q, self.num_heads, sum(self.num_points_list))
        attention_weights = F.softmax(attention_weights, dim=-1).reshape(
            bs, Len_q, self.num_heads, sum(self.num_points_list))
        repeats = torch.tensor(self.num_points_list, device=query.device)
        ref_points_expanded = torch.repeat_interleave(
            reference_points, repeats, dim=2)
        if reference_points.shape[-1] == 2:
            offset_normalizer = torch.tensor(
                value_spatial_shapes, device=query.device)
            offset_normalizer = offset_normalizer.flip([1]).reshape(
                1, 1, 1, self.num_levels, 2)
            offset_norm_expanded = torch.repeat_interleave(
                offset_normalizer, repeats, dim=3)
            sampling_locations = (
                ref_points_expanded[:, :, None, :, :2]
                + sampling_offsets / offset_norm_expanded)
        elif reference_points.shape[-1] == 4:
            num_points_scale = self.num_points_scale.to(
                dtype=query.dtype).unsqueeze(-1)
            offset = (sampling_offsets * num_points_scale
                      * ref_points_expanded[:, :, None, :, 2:]
                      * self.offset_scale)
            sampling_locations = ref_points_expanded[:, :, None, :, :2] + offset
        else:
            raise ValueError(f"ref_points last dim must be 2 or 4, got {reference_points.shape[-1]}")
        output = self.ms_deformable_attn_core(
            value, value_spatial_shapes, sampling_locations,
            attention_weights, self.num_points_list)
        return self.output_proj(output)


class RTDETRDecoderLayer(nn.Module):
    def __init__(self, d_model=256, n_head=8, dim_feedforward=1024,
                 dropout=0.0, activation="relu", n_levels=3,
                 n_points=4, cross_attn_method="discrete"):
        super().__init__()
        self.self_attn = nn.MultiheadAttention(
            d_model, n_head, dropout=dropout, batch_first=True)
        self.dropout1 = nn.Dropout(dropout)
        self.norm1 = nn.LayerNorm(d_model)
        self.cross_attn = MSDeformableAttention(
            d_model, n_head, n_levels, n_points, method=cross_attn_method)
        self.dropout2 = nn.Dropout(dropout)
        self.norm2 = nn.LayerNorm(d_model)
        self.linear1 = nn.Linear(d_model, dim_feedforward)
        self.activation = get_activation(activation)
        self.dropout3 = nn.Dropout(dropout)
        self.linear2 = nn.Linear(dim_feedforward, d_model)
        self.dropout4 = nn.Dropout(dropout)
        self.norm3 = nn.LayerNorm(d_model)
        self._reset_parameters()

    def _reset_parameters(self):
        nn.init.xavier_uniform_(self.linear1.weight)
        nn.init.xavier_uniform_(self.linear2.weight)

    @staticmethod
    def with_pos_embed(tensor, pos):
        return tensor if pos is None else tensor + pos

    def forward(self, target, reference_points, memory,
                memory_spatial_shapes, attn_mask=None,
                memory_mask=None, query_pos_embed=None):
        q = k = self.with_pos_embed(target, query_pos_embed)
        target2, _ = self.self_attn(q, k, value=target, attn_mask=attn_mask)
        target = target + self.dropout1(target2)
        target = self.norm1(target)
        target2 = self.cross_attn(
            self.with_pos_embed(target, query_pos_embed),
            reference_points, memory, memory_spatial_shapes, memory_mask)
        target = target + self.dropout2(target2)
        target = self.norm2(target)
        target2 = self.linear2(self.dropout3(self.activation(self.linear1(target))))
        target = target + self.dropout4(target2)
        target = self.norm3(target)
        return target


class RTDETRDecoder(nn.Module):
    """Iterative-refinement decoder. Enhanced: per-layer task bias."""
    def __init__(self, hidden_dim, decoder_layer, num_layers,
                 num_levels=3, eval_idx=-1):
        super().__init__()
        self.layers = nn.ModuleList(
            [copy.deepcopy(decoder_layer) for _ in range(num_layers)])
        self.hidden_dim = hidden_dim
        self.num_layers = num_layers
        self.num_levels = num_levels
        self.eval_idx = eval_idx if eval_idx >= 0 else num_layers + eval_idx

    def forward(self, target, ref_points_unact, memory,
                memory_spatial_shapes, bbox_head, score_head,
                query_pos_head, attn_mask=None, memory_mask=None,
                task_bias=None):
        dec_out_bboxes, dec_out_logits = [], []
        ref_points_detach = F.sigmoid(ref_points_unact)
        output = target
        for i, layer in enumerate(self.layers):
            ref_points_input = ref_points_detach.unsqueeze(2).tile(
                [1, 1, self.num_levels, 1])
            query_pos_embed = query_pos_head(ref_points_detach)
            # Per-layer task bias injection (spec improvement)
            if task_bias is not None:
                output = output + task_bias.unsqueeze(1)
            output = layer(output, ref_points_input, memory,
                          memory_spatial_shapes, attn_mask, memory_mask,
                          query_pos_embed)
            inter_ref_bbox = F.sigmoid(
                bbox_head[i](output) + inverse_sigmoid(ref_points_detach))
            if self.training:
                dec_out_logits.append(score_head[i](output))
                if i == 0:
                    dec_out_bboxes.append(inter_ref_bbox)
                else:
                    dec_out_bboxes.append(F.sigmoid(
                        bbox_head[i](output) + inverse_sigmoid(ref_points)))
            elif i == self.eval_idx:
                dec_out_logits.append(score_head[i](output))
                dec_out_bboxes.append(inter_ref_bbox)
                break
            ref_points = inter_ref_bbox
            ref_points_detach = inter_ref_bbox.detach()
        return torch.stack(dec_out_bboxes), torch.stack(dec_out_logits), output


class RTDETRTransformerv2(nn.Module):
    """RT-DETRv2 decoder: anchors → top-K → iterative refinement."""
    def __init__(self, num_classes=1, hidden_dim=256, num_queries=300,
                 feat_channels=[256,256,256], feat_strides=[8,16,32],
                 num_levels=3, num_points=[4,4,4], nhead=8, num_layers=6,
                 dim_feedforward=1024, dropout=0.0, activation="relu",
                 num_denoising=0, eval_idx=2, eps=1e-2,
                 cross_attn_method="discrete", query_select_method="agnostic"):
        super().__init__()
        self.hidden_dim = hidden_dim
        self.nhead = nhead
        self.feat_strides = feat_strides
        self.num_levels = num_levels
        self.num_classes = num_classes
        self.num_queries = num_queries
        self.eps = eps
        self.num_layers = num_layers
        self.cross_attn_method = cross_attn_method
        self.query_select_method = query_select_method
        self.input_proj = nn.ModuleList()
        for in_ch in feat_channels:
            self.input_proj.append(nn.Sequential(OrderedDict([
                ("conv", nn.Conv2d(in_ch, hidden_dim, 1, bias=False)),
                ("norm", nn.BatchNorm2d(hidden_dim)),
            ])))
        decoder_layer = RTDETRDecoderLayer(
            hidden_dim, nhead, dim_feedforward, dropout, activation,
            num_levels, num_points, cross_attn_method=cross_attn_method)
        self.decoder = RTDETRDecoder(
            hidden_dim, decoder_layer, num_layers,
            num_levels=num_levels, eval_idx=eval_idx)
        self.query_pos_head = MLP(4, 2 * hidden_dim, hidden_dim, 2)
        self.enc_output = nn.Sequential(OrderedDict([
            ("proj", nn.Linear(hidden_dim, hidden_dim)),
            ("norm", nn.LayerNorm(hidden_dim)),
        ]))
        if query_select_method == "agnostic":
            self.enc_score_head = nn.Linear(hidden_dim, 1)
        else:
            self.enc_score_head = nn.Linear(hidden_dim, num_classes)
        self.enc_bbox_head = MLP(hidden_dim, hidden_dim, 4, 3)
        self.dec_score_head = nn.ModuleList(
            [nn.Linear(hidden_dim, num_classes) for _ in range(num_layers)])
        self.dec_bbox_head = nn.ModuleList(
            [MLP(hidden_dim, hidden_dim, 4, 3) for _ in range(num_layers)])
        self._reset_parameters()

    def _reset_parameters(self):
        bias = bias_init_with_prob(0.01)
        nn.init.constant_(self.enc_score_head.bias, bias)
        nn.init.constant_(self.enc_bbox_head.layers[-1].weight, 0)
        nn.init.constant_(self.enc_bbox_head.layers[-1].bias, 0)
        for cls_h, reg_h in zip(self.dec_score_head, self.dec_bbox_head):
            nn.init.constant_(cls_h.bias, bias)
            nn.init.constant_(reg_h.layers[-1].weight, 0)
            nn.init.constant_(reg_h.layers[-1].bias, 0)
        nn.init.xavier_uniform_(self.enc_output[0].weight)
        nn.init.xavier_uniform_(self.query_pos_head.layers[0].weight)
        nn.init.xavier_uniform_(self.query_pos_head.layers[1].weight)
        for m in self.input_proj:
            nn.init.xavier_uniform_(m[0].weight)

    def _generate_anchors(self, spatial_shapes, grid_size=0.05,
                          dtype=torch.float32, device="cpu"):
        anchors = []
        for lvl, (h, w) in enumerate(spatial_shapes):
            grid_y, grid_x = torch.meshgrid(
                torch.arange(h), torch.arange(w), indexing="ij")
            grid_xy = torch.stack([grid_x, grid_y], dim=-1)
            grid_xy = (grid_xy.unsqueeze(0) + 0.5) / torch.tensor([w, h], dtype=dtype)
            wh = torch.ones_like(grid_xy) * grid_size * (2.0 ** lvl)
            lvl_anchors = torch.concat([grid_xy, wh], dim=-1).reshape(-1, h * w, 4)
            anchors.append(lvl_anchors)
        anchors = torch.concat(anchors, dim=1).to(device)
        valid_mask = ((anchors > self.eps) * (anchors < 1 - self.eps)).all(-1, keepdim=True)
        anchors = torch.log(anchors / (1 - anchors))
        anchors = torch.where(valid_mask, anchors, torch.inf)
        return anchors, valid_mask

    def _get_encoder_input(self, feats):
        proj_feats = [self.input_proj[i](f) for i, f in enumerate(feats)]
        feat_flatten, spatial_shapes = [], []
        for feat in proj_feats:
            _, _, h, w = feat.shape
            feat_flatten.append(feat.flatten(2).permute(0, 2, 1))
            spatial_shapes.append([h, w])
        return torch.concat(feat_flatten, 1), spatial_shapes

    def _select_topk(self, memory, outputs_logits, outputs_coords_unact, topk):
        if self.query_select_method == "agnostic":
            _, topk_ind = torch.topk(outputs_logits.squeeze(-1), topk, dim=-1)
        else:
            _, topk_ind = torch.topk(outputs_logits.max(-1).values, topk, dim=-1)
        topk_coords = outputs_coords_unact.gather(
            dim=1, index=topk_ind.unsqueeze(-1).repeat(1, 1, outputs_coords_unact.shape[-1]))
        topk_logits = outputs_logits.gather(
            dim=1, index=topk_ind.unsqueeze(-1).repeat(1, 1, outputs_logits.shape[-1]))
        topk_memory = memory.gather(
            dim=1, index=topk_ind.unsqueeze(-1).repeat(1, 1, memory.shape[-1]))
        return topk_memory, topk_logits, topk_coords

    def _get_decoder_input(self, memory, spatial_shapes, task_query_bias=None):
        anchors, valid_mask = self._generate_anchors(
            spatial_shapes, device=memory.device)
        memory = valid_mask.to(memory.dtype) * memory
        output_memory = self.enc_output(memory)
        enc_outputs_logits = self.enc_score_head(output_memory)
        enc_outputs_coord_unact = self.enc_bbox_head(output_memory) + anchors
        enc_topk_memory, _, enc_topk_bbox_unact = self._select_topk(
            output_memory, enc_outputs_logits, enc_outputs_coord_unact,
            self.num_queries)
        content = enc_topk_memory.detach()
        if task_query_bias is not None:
            content = content + task_query_bias.unsqueeze(1)
        enc_topk_bbox_unact = enc_topk_bbox_unact.detach()
        return content, enc_topk_bbox_unact

    def forward(self, feats, task_query_bias=None, task_bias_per_layer=None):
        memory, spatial_shapes = self._get_encoder_input(feats)
        content, init_ref = self._get_decoder_input(
            memory, spatial_shapes, task_query_bias)
        out_bboxes, out_logits, dec_hidden = self.decoder(
            content, init_ref, memory, spatial_shapes,
            self.dec_bbox_head, self.dec_score_head, self.query_pos_head,
            task_bias=task_bias_per_layer)
        out = {"pred_logits": out_logits[-1], "pred_boxes": out_bboxes[-1]}
        return out, dec_hidden
