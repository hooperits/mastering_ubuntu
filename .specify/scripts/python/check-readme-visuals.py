#!/usr/bin/env python3
import os
import re
import sys

def check_readme():
    readme_path = "README.md"
    if not os.path.exists(readme_path):
        print(f"ERROR: {readme_path} not found at repository root.")
        return False

    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read()

    success = True

    # 1. Check Heading Structure (Single H1 Header, ignoring code blocks)
    content_no_code = re.sub(r"```.*?```", "", content, flags=re.DOTALL)
    h1_headings = re.findall(r"^#\s+(.*)$", content_no_code, re.MULTILINE)
    if len(h1_headings) == 0:
        print("ERROR: README.md does not contain any H1 header (# Title).")
        success = False
    elif len(h1_headings) > 1:
        print(f"ERROR: README.md contains multiple H1 headers: {h1_headings}. Only one is allowed.")
        success = False
    else:
        print(f"✓ Found exactly one H1 header: '{h1_headings[0]}'")


    # 2. Check local image references
    # Match markdown images: ![alt](path)
    markdown_images = re.findall(r"!\[.*?\]\((.*?)\)", content)
    # Match html images: <img src="path" ...>
    html_images = re.findall(r"<img[^>]+src=[\"']([^\"']+)[\"']", content)

    all_images = markdown_images + html_images
    local_images = [img for img in all_images if not img.startswith(("http://", "https://"))]

    if not local_images:
        print("INFO: No local image references found in README.md.")
    else:
        print(f"Checking {len(local_images)} local image references...")
        for img in local_images:
            # Strip anchors or queries if any
            clean_path = img.split("#")[0].split("?")[0]
            if not os.path.exists(clean_path):
                print(f"ERROR: Referenced local image file does not exist: {clean_path}")
                success = False
            else:
                print(f"✓ Local image path is valid: {clean_path}")

    return success

if __name__ == "__main__":
    print("=== Labyrinth README Visuals & Layout Verification ===")
    if check_readme():
        print("✓ All validation checks passed successfully!")
        sys.exit(0)
    else:
        print("❌ Validation checks failed. Please fix the issues listed above.")
        sys.exit(1)
