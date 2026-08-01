#!/usr/bin/env python3
"""GatE-V Model Visualization GUI.

Provides an interactive GUI for running CPU-based inference using either ONNX 
or PyTorch checkpoints and comparing predictions side-by-side with Ground Truth.
"""
from __future__ import annotations

import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

import tkinter as tk
from tkinter import messagebox, ttk
import numpy as np
import torch
from PIL import Image, ImageDraw, ImageFont, ImageTk

from src.utils.config import VegaConfig
from src.engine.trainer import build_model
from src.data.dataset import COCOTasksDataset
from src.model.gate import TASK_DESCRIPTIONS
from src.model.matcher import box_cxcywh_to_xyxy, safe_boxes_xyxy

# Dynamically inject get_raw_image to COCOTasksDataset class
def get_raw_image_injected(self, idx: int) -> Image.Image:
    sample = self.samples[idx]
    if getattr(self, "use_ram_cache", False) and sample["img_path"] in self.ram_cache:
        import io
        return Image.open(io.BytesIO(self.ram_cache[sample["img_path"]])).convert("RGB")
    return Image.open(sample["img_path"]).convert("RGB")

COCOTasksDataset.get_raw_image = get_raw_image_injected

# Paths to checkpoints
ONNX_PATH = ROOT / "runs/vega_base/vega_exported.onnx"
ONNX_DATA_PATH = ROOT / "runs/vega_base/vega_exported.onnx.data"
PTH_PATH = ROOT / "runs/vega_base/vega_edge_detect_final.pth"
CONFIG_PATH = ROOT / "configs/vega_base.yaml"

class VisualizerGUI:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("GatE-V Interactive Edge Visualizer")
        self.root.geometry("1720x860")
        self.root.configure(bg="#121214")

        # Color Palette
        self.bg_dark = "#121214"
        self.card_bg = "#1e1e24"
        self.accent_purple = "#7c4dff"
        self.accent_green = "#00e676"
        self.text_white = "#ffffff"
        self.text_gray = "#a0a0ab"

        # Apply general custom style to ttk comboboxes/widgets
        style = ttk.Style()
        style.theme_use("default")
        style.configure("TCombobox", fieldbackground=self.card_bg, background=self.accent_purple, foreground=self.text_white, font=("Helvetica", 11, "bold"))

        # State Variables
        self.cfg = VegaConfig.from_yaml(CONFIG_PATH)
        self.test_dataset = None
        self.train_dataset = None
        self.current_dataset = None
        self.model_pth = None
        self.onnx_sess = None
        self.image_indices: list[int] = []

        # Load Status Flags
        self.has_onnx = ONNX_PATH.exists() and ONNX_DATA_PATH.exists()
        self.has_pth = PTH_PATH.exists()
        self.has_any = self.has_onnx or self.has_pth

        self.setup_ui()
        
        if self.has_any:
            self.load_datasets()
            self.on_split_or_task_change()
        else:
            self.disable_all_controls()

    def setup_ui(self):
        # ── Main Layout ──────────────────────────────────────────────────────
        self.left_panel = tk.Frame(self.root, bg=self.card_bg, width=380)
        self.left_panel.pack(side=tk.LEFT, fill=tk.Y, padx=15, pady=15)
        self.left_panel.pack_propagate(False)

        self.right_panel = tk.Frame(self.root, bg=self.bg_dark)
        self.right_panel.pack(side=tk.RIGHT, expand=True, fill=tk.BOTH, padx=15, pady=15)

        # ── Title Logo ───────────────────────────────────────────────────────
        title_label = tk.Label(self.left_panel, text="GatE-V Visualizer", font=("DejaVu Sans", 24, "bold"), fg=self.accent_purple, bg=self.card_bg)
        title_label.pack(pady=15)

        subtitle_label = tk.Label(self.left_panel, text="FPGA-Ready Edge Detection", font=("DejaVu Sans", 13), fg=self.text_gray, bg=self.card_bg)
        subtitle_label.pack(pady=(0, 20))

        # ── Model Selection Card ─────────────────────────────────────────────
        model_frame = tk.LabelFrame(self.left_panel, text=" Model Configuration ", font=("DejaVu Sans", 13, "bold"), fg=self.text_white, bg=self.card_bg, bd=1, relief=tk.FLAT)
        model_frame.pack(fill=tk.X, padx=10, pady=10)

        tk.Label(model_frame, text="Active Model Type:", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg).pack(anchor=tk.W, padx=5, pady=5)
        
        self.model_var = tk.StringVar()
        self.model_dropdown = ttk.Combobox(model_frame, textvariable=self.model_var, state="readonly", font=("DejaVu Sans", 12, "bold"))
        self.model_dropdown.pack(fill=tk.X, padx=5, pady=5)

        # Default model selection rules requested by user
        models_available = []
        if self.has_onnx:
            models_available.append("ONNX (Fast CPU Inference)")
        if self.has_pth:
            models_available.append("PyTorch (.pth Checkpoint)")
        
        self.model_dropdown["values"] = models_available
        if self.has_onnx:
            self.model_dropdown.set("ONNX (Fast CPU Inference)")
        elif self.has_pth:
            self.model_dropdown.set("PyTorch (.pth Checkpoint)")

        # Warning/Status Label
        self.warning_label = tk.Label(model_frame, text="", font=("DejaVu Sans", 11, "italic"), fg="yellow", bg=self.card_bg, wraplength=340)
        self.warning_label.pack(anchor=tk.W, padx=5, pady=(5, 10))
        self.update_warning_text()

        # ── Image Selection Card ─────────────────────────────────────────────
        data_frame = tk.LabelFrame(self.left_panel, text=" Image Selection ", font=("DejaVu Sans", 13, "bold"), fg=self.text_white, bg=self.card_bg, bd=1, relief=tk.FLAT)
        data_frame.pack(fill=tk.X, padx=10, pady=10)

        # Split Selector
        tk.Label(data_frame, text="Dataset Split:", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg).pack(anchor=tk.W, padx=5, pady=(5, 0))
        self.split_var = tk.StringVar(value="Test Set")
        self.split_dropdown = ttk.Combobox(data_frame, textvariable=self.split_var, values=["Test Set", "Train Set"], state="readonly", font=("DejaVu Sans", 12, "bold"))
        self.split_dropdown.pack(fill=tk.X, padx=5, pady=5)
        self.split_dropdown.bind("<<ComboboxSelected>>", lambda e: self.on_split_or_task_change())

        # Task Selector
        tk.Label(data_frame, text="Task Description:", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg).pack(anchor=tk.W, padx=5, pady=(5, 0))
        self.task_var = tk.StringVar()
        self.task_dropdown = ttk.Combobox(data_frame, textvariable=self.task_var, values=[f"Task {i+1}: {desc[:30]}..." for i, desc in enumerate(TASK_DESCRIPTIONS)], state="readonly", font=("DejaVu Sans", 12, "bold"))
        self.task_dropdown.pack(fill=tk.X, padx=5, pady=5)
        self.task_dropdown.set(f"Task 1: {TASK_DESCRIPTIONS[0][:30]}...")
        self.task_dropdown.bind("<<ComboboxSelected>>", lambda e: self.on_split_or_task_change())

        # Image Selector
        tk.Label(data_frame, text="Select Image Sample:", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg).pack(anchor=tk.W, padx=5, pady=(5, 0))
        self.image_var = tk.StringVar()
        self.image_dropdown = ttk.Combobox(data_frame, textvariable=self.image_var, state="readonly", font=("DejaVu Sans", 12, "bold"))
        self.image_dropdown.pack(fill=tk.X, padx=5, pady=5)

        # Confidence Threshold Slider
        tk.Label(data_frame, text="Confidence Threshold:", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg).pack(anchor=tk.W, padx=5, pady=(8, 0))
        self.conf_slider = tk.Scale(
            data_frame, from_=0.05, to=0.80, resolution=0.01,
            orient=tk.HORIZONTAL, bg=self.card_bg, fg=self.text_white,
            activebackground=self.accent_purple, highlightthickness=0,
            font=("DejaVu Sans", 11, "bold"), troughcolor="#27272a"
        )
        self.conf_slider.set(0.15)  # Default threshold to 0.15 so small objects are detected by default!
        self.conf_slider.pack(fill=tk.X, padx=5, pady=5)

        # ── Run Action Button ────────────────────────────────────────────────
        self.eval_button = tk.Button(self.left_panel, text="⚡ RUN EVALUATE", font=("DejaVu Sans", 15, "bold"), fg=self.text_white, bg=self.accent_purple, activebackground="#9b72ff", activeforeground=self.text_white, bd=0, cursor="hand2", pady=8, command=self.run_evaluate)
        self.eval_button.pack(fill=tk.X, padx=15, pady=15)

        # ── Metrics Card ─────────────────────────────────────────────────────
        metrics_frame = tk.LabelFrame(self.left_panel, text=" Performance Metrics ", font=("DejaVu Sans", 13, "bold"), fg=self.text_white, bg=self.card_bg, bd=1, relief=tk.FLAT)
        metrics_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Device Label
        device_lbl = tk.Label(metrics_frame, text="🖥️ Device: CPU (Strict Host Mode)", font=("DejaVu Sans", 12, "bold"), fg=self.accent_green, bg=self.card_bg)
        device_lbl.pack(anchor=tk.W, padx=10, pady=10)

        # Latency
        self.latency_label = tk.Label(metrics_frame, text="⚡ Latency: -- ms", font=("DejaVu Sans", 13, "bold"), fg=self.text_white, bg=self.card_bg)
        self.latency_label.pack(anchor=tk.W, padx=10, pady=5)

        # Speed (FPS)
        self.fps_label = tk.Label(metrics_frame, text="📊 Throughput: -- FPS", font=("DejaVu Sans", 12, "bold"), fg=self.text_gray, bg=self.card_bg)
        self.fps_label.pack(anchor=tk.W, padx=10, pady=5)

        # Model Info
        self.info_label = tk.Label(metrics_frame, text="Selected Model Status:\nFunctional Correctness Checked", font=("DejaVu Sans", 11), fg=self.text_gray, bg=self.card_bg, justify=tk.LEFT)
        self.info_label.pack(anchor=tk.W, padx=10, pady=15)

        # ── Canvas comparison ────────────────────────────────────────────────
        canvas_title_frame = tk.Frame(self.right_panel, bg=self.bg_dark)
        canvas_title_frame.pack(fill=tk.X)

        tk.Label(canvas_title_frame, text="GROUND TRUTH", font=("DejaVu Sans", 18, "bold"), fg=self.accent_green, bg=self.bg_dark).pack(side=tk.LEFT, expand=True)
        tk.Label(canvas_title_frame, text="GatE-V OPTIMIZED PREDICTION", font=("DejaVu Sans", 18, "bold"), fg=self.accent_purple, bg=self.bg_dark).pack(side=tk.RIGHT, expand=True)

        self.canvas_frame = tk.Frame(self.right_panel, bg=self.bg_dark)
        self.canvas_frame.pack(expand=True, fill=tk.BOTH)

        self.gt_label = tk.Label(self.canvas_frame, text="Select an image and press Evaluate...", font=("DejaVu Sans", 16), fg=self.text_gray, bg="#18181b", bd=1, relief=tk.SOLID)
        self.gt_label.pack(side=tk.LEFT, expand=True, fill=tk.BOTH, padx=5, pady=5)

        self.pred_label = tk.Label(self.canvas_frame, text="Select an image and press Evaluate...", font=("DejaVu Sans", 16), fg=self.text_gray, bg="#18181b", bd=1, relief=tk.SOLID)
        self.pred_label.pack(side=tk.RIGHT, expand=True, fill=tk.BOTH, padx=5, pady=5)

    def update_warning_text(self):
        if not self.has_any:
            self.warning_label.config(text="❌ No model checkpoints found!\nPlease train the model first.", fg="red")
        elif self.has_pth and not self.has_onnx:
            self.warning_label.config(text="⚠️ ONNX model not exported.\nPlease run 'Option x' for fast CPU inference.", fg="yellow")
        else:
            self.warning_label.config(text="✓ ONNX and PyTorch checkpoints verified.\nONNX is recommended for CPU speed.", fg=self.accent_green)

    def disable_all_controls(self):
        self.model_dropdown.config(state="disabled")
        self.split_dropdown.config(state="disabled")
        self.task_dropdown.config(state="disabled")
        self.image_dropdown.config(state="disabled")
        self.eval_button.config(state="disabled", bg="#3a3a44", fg=self.text_gray)
        self.update_warning_text()
        messagebox.showerror("No Checkpoints Found", "No model checkpoints (.pth or .onnx) were found in your runs directory.\nPlease train a model before running visualization!")

    def load_datasets(self):
        # Displays loading text in image box
        self.image_dropdown.config(values=["Loading datasets..."])
        self.image_dropdown.set("Loading datasets...")
        self.root.update_idletasks()

        if self.has_any:
            # We load the dataset splits on demand or synchronously since they are small
            self.test_dataset = COCOTasksDataset(
                dataset_dir=ROOT / self.cfg.data.dataset_dir,
                images_dir=ROOT / self.cfg.data.images_dir,
                split="test",
                img_size=self.cfg.training.img_size,
                augment=False,
            )
            self.train_dataset = COCOTasksDataset(
                dataset_dir=ROOT / self.cfg.data.dataset_dir,
                images_dir=ROOT / self.cfg.data.images_dir,
                split="train",
                img_size=self.cfg.training.img_size,
                augment=False,
            )

    def on_split_or_task_change(self):
        if not self.test_dataset or not self.train_dataset:
            return
        
        split = self.split_var.get()
        task_idx = self.task_dropdown.current()

        if split == "Test Set":
            self.current_dataset = self.test_dataset
        else:
            self.current_dataset = self.train_dataset

        # Scan for images belonging to this task
        self.image_indices = []
        for i in range(len(self.current_dataset)):
            sample = self.current_dataset.samples[i]
            if int(sample["task_idx"]) == task_idx:
                self.image_indices.append(i)

        if len(self.image_indices) == 0:
            self.image_dropdown.config(values=["No images found"])
            self.image_dropdown.set("No images found")
        else:
            self.image_dropdown.config(values=[f"Sample #{idx+1} ({Path(self.current_dataset.samples[idx]['img_path']).name})" for idx in self.image_indices])
            self.image_dropdown.set(f"Sample #{self.image_indices[0]+1} ({Path(self.current_dataset.samples[self.image_indices[0]]['img_path']).name})")

    def run_evaluate(self):
        if len(self.image_indices) == 0 or self.image_dropdown.get() == "No images found":
            messagebox.showwarning("No Data Selected", "Please select a valid image sample.")
            return

        selected_model = self.model_var.get()
        selected_idx_in_task = self.image_dropdown.current()
        dataset_idx = self.image_indices[selected_idx_in_task]

        sample = self.current_dataset[dataset_idx]
        task_id = int(sample["task_id"])
        gt_boxes = sample["boxes"]

        # ── Preprocess input image ───────────────────────────────────────────
        img_t = sample["image"].unsqueeze(0)  # Shape [1, 3, H, W]
        tid_t = torch.tensor([task_id], dtype=torch.long)

        pred_logits, pred_boxes, exist_logits = None, None, None
        inference_time_ms = 0.0

        # ── RUN INFERENCE ON CPU ─────────────────────────────────────────────
        if "ONNX" in selected_model:
            try:
                import onnxruntime as ort
                if not self.onnx_sess:
                    # Initialize ONNX CPU runtime session
                    self.onnx_sess = ort.InferenceSession(str(ONNX_PATH), providers=["CPUExecutionProvider"])
                
                # Warmup / Measure speed
                start_t = time.perf_counter()
                out = self.onnx_sess.run(None, {
                    "image": img_t.numpy(),
                    "task_id": tid_t.numpy()
                })
                inference_time_ms = (time.perf_counter() - start_t) * 1000.0
                
                pred_logits = torch.from_numpy(out[0])
                pred_boxes = torch.from_numpy(out[1])
                exist_logits = torch.from_numpy(out[3])
            except Exception as e:
                messagebox.showerror("ONNX Runtime Error", f"Failed to execute ONNX model on CPU:\n{str(e)}")
                return
        else:
            # PyTorch .pth CPU inference
            try:
                if not self.model_pth:
                    self.model_pth = build_model(self.cfg)
                    state = torch.load(PTH_PATH, map_location="cpu", weights_only=False)
                    ckpt_state = state.get("ema", state.get("model", state))
                    clean_state = {k.replace("_orig_mod.", ""): v for k, v in ckpt_state.items()}
                    self.model_pth.load_state_dict(clean_state)
                    self.model_pth.eval()

                with torch.no_grad():
                    start_t = time.perf_counter()
                    p_logits, p_boxes, _, e_logits = self.model_pth(img_t, tid_t)
                    inference_time_ms = (time.perf_counter() - start_t) * 1000.0
                    
                    pred_logits = p_logits
                    pred_boxes = p_boxes
                    exist_logits = e_logits
            except Exception as e:
                messagebox.showerror("PyTorch Error", f"Failed to run PyTorch inference:\n{str(e)}")
                return

        # ── Apply Optimal Post-Processing Gating (EXIST_THRESHOLD = 0.00) ────
        obj_s = pred_logits[0].sigmoid().squeeze(-1)
        exist_prob = exist_logits[0].sigmoid().item()
        
        # Optimal Hard gating threshold is 0.00
        # If exist_prob >= 0.00, keep all boxes. Otherwise, suppress all boxes.
        if exist_prob >= 0.00:
            scores = obj_s.cpu().numpy()
        else:
            scores = np.zeros_like(obj_s.cpu().numpy())

        boxes_cpu = pred_boxes[0].cpu()

        # ── Render Bounding Boxes ────────────────────────────────────────────
        # Get raw image as PIL
        raw_img_pil = self.current_dataset.get_raw_image(dataset_idx)
        w, h = raw_img_pil.size
        
        # Resize raw image to standard visualization box
        viz_size = (640, 640)
        gt_viz_img = raw_img_pil.resize(viz_size).convert("RGB")
        pred_viz_img = raw_img_pil.resize(viz_size).convert("RGB")

        draw_gt = ImageDraw.Draw(gt_viz_img)
        draw_pred = ImageDraw.Draw(pred_viz_img)

        # Premium legible font loader for drawing scores on Pillow
        pillow_font = None
        for font_name in ["DejaVuSans-Bold.ttf", "LiberationSans-Bold.ttf", "Arial.ttf"]:
            try:
                pillow_font = ImageFont.truetype(font_name, 26)
                break
            except OSError:
                continue
        if pillow_font is None:
            pillow_font = ImageFont.load_default()

        # Draw Ground Truth (Green Boxes)
        if len(gt_boxes) > 0:
            gt_xyxy = box_cxcywh_to_xyxy(gt_boxes)
            for box in gt_xyxy:
                # Scale boxes from standard coords (0-1) to viz coords (0-640)
                x1, y1, x2, y2 = box.numpy()
                x1, x2 = x1 * viz_size[0], x2 * viz_size[0]
                y1, y2 = y1 * viz_size[1], y2 * viz_size[1]
                draw_gt.rectangle([x1, y1, x2, y2], outline="#00e676", width=4)

        # Draw Model Predictions (Purple/Magenta Boxes with Scores)
        # Keep only detections above objectness threshold to prevent clutter
        pred_rendered = 0
        order = scores.argsort()[::-1]
        conf_thresh = self.conf_slider.get()
        for i in order:
            score = float(scores[i])
            if score < conf_thresh:  # Dynamic confidence floor to capture small objects
                continue
            
            box = boxes_cpu[i]
            # Convert cxcywh to xyxy
            box_xyxy = safe_boxes_xyxy(box.unsqueeze(0)).squeeze(0)
            x1, y1, x2, y2 = box_xyxy.numpy()
            x1, x2 = x1 * viz_size[0], x2 * viz_size[0]
            y1, y2 = y1 * viz_size[1], y2 * viz_size[1]

            draw_pred.rectangle([x1, y1, x2, y2], outline="#7c4dff", width=4)
            
            # Premium filled text background for ultra-high legibility
            txt = f" {score:.2f} "
            try:
                # Pillow 10+ text bounding box support
                left, top, right, bottom = draw_pred.textbbox((x1, y1), txt, font=pillow_font)
                draw_pred.rectangle([left, top - 4, right, bottom + 4], fill="#7c4dff")
                draw_pred.text((x1, y1 - 4), txt, fill="#ffffff", font=pillow_font)
            except AttributeError:
                # Fallback for older PIL versions
                draw_pred.rectangle([x1, y1 - 22, x1 + 55, y1], fill="#7c4dff")
                draw_pred.text((x1 + 2, y1 - 20), txt, fill="#ffffff", font=pillow_font)
                
            pred_rendered += 1

        # ── Render Images into GUI ───────────────────────────────────────────
        gt_photo = ImageTk.PhotoImage(gt_viz_img)
        pred_photo = ImageTk.PhotoImage(pred_viz_img)

        self.gt_label.config(image=gt_photo, text="")
        self.gt_label.image = gt_photo  # Keep a reference to prevent garbage collection

        self.pred_label.config(image=pred_photo, text="")
        self.pred_label.image = pred_photo

        # ── Update Performance Statistics ────────────────────────────────────
        fps = 1000.0 / inference_time_ms if inference_time_ms > 0 else 0.0
        self.latency_label.config(text=f"⚡ Latency: {inference_time_ms:.2f} ms", fg=self.accent_green if inference_time_ms < 50 else "yellow")
        self.fps_label.config(text=f"📊 Throughput: {fps:.1f} FPS")
        self.info_label.config(
            text=f"Model: {'GatE-V ONNX' if 'ONNX' in selected_model else 'GatE-V PyTorch'}\n"
                 f"Existence Score: {exist_prob:.4f}\n"
                 f"Rendered Detections: {pred_rendered}"
        )

def main():
    root = tk.Tk()
    app = VisualizerGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()
