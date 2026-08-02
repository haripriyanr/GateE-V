import os
import sys
import json
import base64
import argparse
import time
import re
from pathlib import Path
from collections import defaultdict

try:
    from tqdm import tqdm
except ImportError:
    print("Warning: tqdm not found. Progress bar will be disabled.")
    def tqdm(iterable, *args, **kwargs):
        return iterable

try:
    from openai import OpenAI, APIConnectionError, APIError, RateLimitError
    OPENAI_AVAILABLE = True
except ImportError:
    OpenAI = None
    OPENAI_AVAILABLE = False
    try:
        import requests
        REQUESTS_AVAILABLE = True
    except ImportError:
        REQUESTS_AVAILABLE = False


PROMPT_TEMPLATE = """You are a strict dataset quality checker for a task-driven object detection system.

TASK: "{task_description}"

Look at this image and answer these 3 questions:
1. Does the image contain at least one clearly visible object that could realistically be used to accomplish the task?
2. Is the relevant object clearly visible (not >50% occluded, not smaller than ~32x32 pixels in the scene)?
3. Would a reasonable adult agree this object is useful for this specific task?

RULES:
- Be STRICT. Quality over quantity. When in doubt, REJECT.
- The object must be PLAUSIBLE for the task. A spoon is plausible for "get a lemon out of tea". A car is not.
- If the image is blurry, poorly lit, or the object is barely visible, REJECT.

Respond with EXACTLY this format:
VERDICT: [ACCEPT/REJECT]
RELEVANT_OBJECTS: [list the objects useful for this task]
REASON: [one sentence explanation]"""

def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def parse_mimo_response(response_text):
    verdict_match = re.search(r'VERDICT:\s*(ACCEPT|REJECT)', response_text, re.IGNORECASE)
    reason_match = re.search(r'REASON:\s*(.*)', response_text, re.IGNORECASE)
    
    verdict = verdict_match.group(1).upper() if verdict_match else "UNKNOWN"
    reason = reason_match.group(1).strip() if reason_match else ""
    
    return verdict, reason

def call_api_openai(client, model, base64_image, prompt, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model=model,
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {"type": "text", "text": prompt},
                            {
                                "type": "image_url",
                                "image_url": {
                                    "url": f"data:image/jpeg;base64,{base64_image}"
                                },
                            },
                        ],
                    }
                ],
                max_tokens=300,
            )
            return response.choices[0].message.content
        except RateLimitError:
            print(f"Rate limited. Waiting {2**(attempt+1)}s before retry...")
            time.sleep(2**(attempt+1))
        except (APIConnectionError, APIError) as e:
            print(f"API Error: {e}. Retrying in {2**(attempt+1)}s...")
            time.sleep(2**(attempt+1))
        except Exception as e:
            print(f"Unexpected error: {e}. Retrying in {2**(attempt+1)}s...")
            time.sleep(2**(attempt+1))
    
    return None

def call_api_requests(api_url, api_key, model, base64_image, prompt, max_retries=3):
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }
    
    payload = {
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
            }
        ],
        "max_tokens": 300
    }
    
    for attempt in range(max_retries):
        try:
            response = requests.post(f"{api_url}/chat/completions", headers=headers, json=payload)
            response.raise_for_status()
            data = response.json()
            return data["choices"][0]["message"]["content"]
        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}. Retrying in {2**(attempt+1)}s...")
            time.sleep(2**(attempt+1))
            
    return None

def verify_candidate(candidate, args, client):
    # If mode is manual or API failed
    if args.mode == "manual":
        print(f"\nImage: {candidate['image_path']}")
        print(f"Task: {candidate.get('task_description', 'Task ' + str(candidate.get('task_id')))}")
        while True:
            choice = input("Verdict (A)ccept / (R)eject / (S)kip: ").strip().lower()
            if choice in ['a', 'accept']:
                return "ACCEPT", "Manual approval"
            elif choice in ['r', 'reject']:
                return "REJECT", "Manual rejection"
            elif choice in ['s', 'skip']:
                return "UNKNOWN", "Skipped"
            else:
                print("Invalid choice.")
                
    if args.mode == "prompt-only":
        prompt = PROMPT_TEMPLATE.format(task_description=candidate.get('task_description', f"Task {candidate.get('task_id')}"))
        print(f"\n--- PROMPT FOR {candidate['image_path']} ---")
        print(prompt)
        print("------------------------------------------")
        return "UNKNOWN", "Prompt-only mode"

    # API verification
    image_path = candidate.get('image_path')
    if not image_path or not os.path.exists(image_path):
        return "REJECT", "File not found"
        
    try:
        base64_image = encode_image(image_path)
    except Exception as e:
        return "REJECT", f"Error reading image: {e}"
        
    prompt = PROMPT_TEMPLATE.format(task_description=candidate.get('task_description', f"Task {candidate.get('task_id')}"))
    
    response_text = None
    if OPENAI_AVAILABLE and client:
        response_text = call_api_openai(client, args.model, base64_image, prompt)
    elif REQUESTS_AVAILABLE:
        response_text = call_api_requests(args.api_url, args.api_key, args.model, base64_image, prompt)
    else:
        print("No API client available. Falling back to manual mode.")
        args.mode = "manual"
        return verify_candidate(candidate, args, None)
        
    if not response_text:
        print("API call failed after retries. Falling back to manual mode.")
        args.mode = "manual"
        return verify_candidate(candidate, args, None)
        
    verdict, reason = parse_mimo_response(response_text)
    if verdict == "UNKNOWN":
        print(f"Warning: Could not parse verdict from response. Falling back to manual mode for {image_path}")
        print("API Response:", response_text)
        args.mode = "manual"
        return verify_candidate(candidate, args, None)
        
    return verdict, reason

def main():
    parser = argparse.ArgumentParser(description="Verify crawled COCO candidate images using MiMo v2.5")
    parser.add_argument("--mode", choices=["batch", "interval", "manual", "prompt-only"], default="batch",
                        help="Verification mode (default: batch)")
    parser.add_argument("--every", type=int, default=5,
                        help="Interval for interval mode (default: 5)")
    parser.add_argument("--api-url", default="http://localhost:11434/v1",
                        help="API base URL (default: http://localhost:11434/v1)")
    parser.add_argument("--api-key", default=os.environ.get("OPENAI_API_KEY", "not-needed"),
                        help="API key (default: from OPENAI_API_KEY env var or 'not-needed')")
    parser.add_argument("--model", default="mimo-v2.5",
                        help="Model name (default: mimo-v2.5)")
    parser.add_argument("--manifest", default="data/crawled_candidates/manifest.json",
                        help="Path to manifest.json")
    parser.add_argument("--task", type=str,
                        help="Only verify specific task (ID)")
    parser.add_argument("--max", type=int,
                        help="Max candidates to verify this run")
    
    args = parser.parse_args()
    
    manifest_path = Path(args.manifest)
    if not manifest_path.exists():
        print(f"Error: Manifest not found at {manifest_path}")
        sys.exit(1)
        
    with open(manifest_path, 'r') as f:
        manifest_data = json.load(f)
        
    # Standardize format based on expected structure
    candidates = []
    if isinstance(manifest_data, dict) and 'candidates' in manifest_data:
        candidates = manifest_data['candidates']
    elif isinstance(manifest_data, list):
        candidates = manifest_data
    else:
        print("Error: Unknown manifest format.")
        sys.exit(1)
        
    client = None
    if args.mode in ["batch", "interval"] and OPENAI_AVAILABLE:
        client = OpenAI(base_url=args.api_url, api_key=args.api_key)
        
    # Filter candidates to verify
    pending_candidates = []
    for c in candidates:
        if c.get("status") not in ["ACCEPT", "REJECT", "VERIFIED"]:
            if not args.task or str(c.get("task_id")) == args.task:
                pending_candidates.append(c)
                
    if args.max:
        pending_candidates = pending_candidates[:args.max]
        
    print(f"Found {len(pending_candidates)} pending candidates to verify.")
    if len(pending_candidates) == 0:
        return
        
    processed_count = 0
    task_stats = defaultdict(lambda: {"total": 0, "accepted": 0, "rejected": 0})
    
    try:
        for idx, candidate in enumerate(tqdm(pending_candidates, desc="Verifying candidates")):
            task_id = str(candidate.get("task_id", "Unknown"))
            
            # Interval mode logic
            is_interval_auto_accept = False
            if args.mode == "interval" and idx % args.every != 0:
                stats = task_stats[task_id]
                if stats["total"] > 0:
                    pass_rate = stats["accepted"] / stats["total"]
                    if pass_rate > 0.90:
                        is_interval_auto_accept = True
            
            if is_interval_auto_accept:
                verdict = "ACCEPT"
                reason = "Auto-accepted via interval mode (pass rate > 90%)"
            else:
                verdict, reason = verify_candidate(candidate, args, client)
            
            if verdict != "UNKNOWN":
                candidate["status"] = verdict
                candidate["reason"] = reason
                
                stats = task_stats[task_id]
                stats["total"] += 1
                if verdict == "ACCEPT":
                    stats["accepted"] += 1
                elif verdict == "REJECT":
                    stats["rejected"] += 1
                    
                processed_count += 1
                
                # Checkpoint every 10 verifications
                if processed_count % 10 == 0:
                    with open(manifest_path, 'w') as f:
                        if isinstance(manifest_data, dict):
                            manifest_data["candidates"] = candidates
                            json.dump(manifest_data, f, indent=2)
                        else:
                            json.dump(candidates, f, indent=2)
                            
    except KeyboardInterrupt:
        print("\nVerification interrupted by user. Saving checkpoint...")
    
    # Save final manifest
    with open(manifest_path, 'w') as f:
        if isinstance(manifest_data, dict):
            manifest_data["candidates"] = candidates
            json.dump(manifest_data, f, indent=2)
        else:
            json.dump(candidates, f, indent=2)
            
    print(f"\nVerification complete. Processed {processed_count} candidates.")
    
    # Generate report
    report_lines = ["Verification Summary", "="*20, ""]
    
    for task_id, stats in sorted(task_stats.items()):
        total = stats["total"]
        if total > 0:
            accepted = stats["accepted"]
            pct = (accepted / total) * 100
            task_desc = ""
            for c in candidates:
                if str(c.get("task_id")) == task_id and "task_description" in c:
                    task_desc = f" ({c['task_description']})"
                    break
            
            line = f"Task {task_id}{task_desc}: {accepted}/{total} accepted ({pct:.1f}%)"
            print(line)
            report_lines.append(line)
            
    report_path = manifest_path.parent / "verification_report.txt"
    with open(report_path, "w") as f:
        f.write("\n".join(report_lines))
    print(f"\nReport saved to {report_path}")

if __name__ == "__main__":
    main()
