import json
import sys
from pathlib import Path


def update_timeline():
    json_path = Path("docs/timeline.json")
    timeline_dir = Path("docs/timeline")

    if not json_path.exists():
        print(f"Error: {json_path} not found.")
        sys.exit(1)

    # Load the JSON timeline data
    try:
        with open(json_path, "r") as f:
            old_json_content = f.read()
            data = json.loads(old_json_content)
    except Exception as e:
        print(f"Error loading {json_path}: {e}")
        sys.exit(1)

    updated_count = 0
    for entry in data:
        content_id = entry.get("content_id")
        if not content_id:
            print(
                f"Warning: Entry with title '{entry.get('title')}' has no 'content_id'. Skipping..."
            )
            continue

        md_path = timeline_dir / f"{content_id}.md"

        if md_path.exists():
            # Read and format the markdown content
            content = md_path.read_text().strip()
            # Replace double newlines with <br/><br/>
            # and single newlines with spaces (joining lines within paragraphs)
            formatted_content = content.replace("\n\n", "<br/><br/>").replace("\n", " ")

            if entry.get("content") != formatted_content:
                entry["content"] = formatted_content
                updated_count += 1
                print(f"Updated content for '{content_id}'")
        else:
            print(f"No markdown found for '{content_id}' (expected {md_path})")

    if updated_count == 0:
        print("No changes needed.")
        return

    # Write the updated JSON back
    new_json_content = json.dumps(data, indent=2, ensure_ascii=False) + "\n"

    if old_json_content == new_json_content:
        print("No changes to JSON file content.")
        return

    try:
        with open(json_path, "w") as f:
            f.write(new_json_content)
    except Exception as e:
        print(f"Error writing to {json_path}: {e}")
        sys.exit(1)

    print(f"\nSuccessfully updated {updated_count} entries in {json_path}")
    # Return non-zero exit code if we modified the file, so pre-commit hook fails
    sys.exit(1)


if __name__ == "__main__":
    update_timeline()
