# GatE-V:

Welcome! This guide explains how our AI model works using simple analogies.

---

## 1. The Dataset: Our "Golden Sticker" Library 📚
Imagine a library with **63,000 photos**. 
- In some photos, there are objects like cars, dogs, or people.
- Some photos are completely empty or have boring stuff we don't care about.

We have a list of **14 specific "Tasks"** (like "Find the preferred car" or "Find the preferred dog").
- Our job is to put a **"Golden Sticker"** (a bounding box) only on the objects that the user actually wants for that specific task.
- If the photo doesn't have the object we want, we should stay quiet and do nothing.

---

## 2. The Backbone (HGNetV2-B1): The Magnifying Glass 🔍
The "Backbone" is the first part of the model. Think of it as a **world-class detective** with a powerful magnifying glass.
- It looks at the pixels of the photo and identifies **textures and shapes**. 
- It says: "I see a round shape here (maybe a wheel)" or "I see a fuzzy texture here (maybe fur)."
- It doesn't know *what* the object is yet; it just extracts the "clues."

---

## 3. CLIP: The Multi-Lingual Translator 🌍🗣️
CLIP is a special AI from OpenAI that was trained on the entire internet. It knows two languages: **Human Language** and **Visual Language**.
- When we give the model a task like "Find the preferred car," CLIP translates that sentence into a **"Visual Idea."**
- It tells our model: "Hey, a 'preferred car' usually looks like this shiny, metallic, four-wheeled shape."
- This helps our model understand *what* to look for before it even starts searching.

---

## 4. RT-DETR: The 200 Searchers 🏃‍♂️
RT-DETR is the "brain" of the operation. It sends out **200 "Searchers"** (we call them Queries) into the photo.
- Each Searcher looks at a different spot and asks: "Is there a preferred object here?"
- If a Searcher is 90% sure, it draws a box and says "I found it!"

---

## 5. Our Special Modifications: GatE-V ⚡

This is what makes **YOUR** model special. We added two "Upgrades" to make it smarter:

### A. The FGTQ Gate (The Noise-Cancelling Headphones) 🎧
In a normal model, the searchers get distracted by everything in the photo. 
- We added a **"Gate."** When you give the model a task (e.g., "Find Dogs"), the Gate acts like noise-cancelling headphones. 
- It tells the Backbone: "Ignore the trees, ignore the sky, ignore the cars. Only highlight the pixels that look like dogs."
- This makes the model much more focused and faster.

### B. The Existence Head (The Security Guard) 💂‍♂️
Before we added this, the model was "over-eager." It would try to find a car even if the photo was of a desert! This caused "False Positives."
- We added a **"Security Guard"** (the Existence Head).
- The Guard looks at the *entire* photo at once and asks: **"Is there even a point in looking?"**
- If the Guard says "No," the model is forced to output zero boxes. 
- This fixed the problem where your model was seeing "ghosts" in empty images!

---

## 6. Training Infrastructure (v3.1) 💻
We fully optimized the codebase for offline training on an **RTX 4060 Mobile (8GB VRAM)**.
- **No Cloud Required**: We stripped all cloud flags and dependencies. You train it fully on your own laptop.
- **VRAM Optimized**: The model runs an effective batch size of 128 (batch 8, grad accumulation 16) with AMP (Automatic Mixed Precision) and disables native Torch compilation to avoid memory crashes on 8GB cards.
- **Fast Smoke Testing**: You can run `./run.sh --debug` to instantly limit the dataset to 100 images and test exactly 2 epochs. This lets you debug the whole pipeline in 5 minutes instead of wasting 36 hours.

---

## Summary of the "Pipeline"
1. **Input**: A photo + A Task ("Find a Cat").
2. **CLIP**: Explains what a cat looks like to the model.
3. **Backbone**: Scans the photo for shapes.
4. **FGTQ Gate**: Filters out everything that isn't cat-shaped.
5. **Security Guard**: Double-checks if a cat actually exists in this photo.
6. **RT-DETR**: If the guard says yes, 200 searchers find the exact spot of the cat.
7. **Output**: A nice box around the cat! 🐱✅

---
*Created for the DVCon India 2026 Design Contest.*
