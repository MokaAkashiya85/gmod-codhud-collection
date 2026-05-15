import os
import json
import re
from pathlib import Path

JSON_ROOT = Path("_localizationfiles")
PROP_ROOT = Path("resource/localization")

def clean_text(text: str) -> str:
    text = re.sub(r"\^\d", "", text)      # ^1 ^2 ^3 etc.
    text = re.sub(r"&&\d+", "%s", text)   # &&1 → %s
    return text.strip()

def load_json_map(json_file: Path):
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    return {
        key: clean_text(str(value))
        for key, value in data.items()
    }

def load_all_json(game: str):
    folder = JSON_ROOT / game
    json_maps = {}

    for file in folder.glob("*.json"):
        # keep ALL languages except optionally skip en.json if desired
        lang = file.stem.lower()
        json_maps[lang] = load_json_map(file)

    return json_maps

def load_properties(file_path: Path):
    lines = []

    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            lines.append(line.rstrip("\n"))

    return lines

def write_properties(file_path: Path, lines):
    with open(file_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

def process(game: str, prefix: str):
    json_maps = load_all_json(game)

    if not json_maps:
        print("No JSON files found.")
        return

    for prop_file in PROP_ROOT.glob("**/*.properties"):
        if game.lower() not in prop_file.name.lower():
            continue

        print(f"\nProcessing {prop_file}")

        lines = load_properties(prop_file)
        updated_lines = []

        # determine language from folder name (en/de/fr)
        lang = prop_file.parent.name.lower()

        if lang not in json_maps:
            print(f"Skipping {prop_file} (no matching JSON language: {lang})")
            continue

        json_data = json_maps[lang]

        for line in lines:
            if "=" not in line or line.startswith("#"):
                updated_lines.append(line)
                continue

            key, value = line.split("=", 1)

            if not key.startswith(prefix):
                updated_lines.append(line)
                continue

            json_key = key[len(prefix):]

            if json_key in json_data:
                new_value = json_data[json_key]
                updated_lines.append(f"{key}={new_value}")
            else:
                updated_lines.append(line)

        write_properties(prop_file, updated_lines)
        print(f"Updated {prop_file}")

if __name__ == "__main__":
    game = input("Game folder (e.g. bo1, mw2): ").strip()
    prefix = input("Prefix (e.g. BO1_): ").strip()

    process(game, prefix)