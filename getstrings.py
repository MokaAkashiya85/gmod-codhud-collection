import os
import re
from collections import defaultdict

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

ROOT = os.path.join(
    SCRIPT_DIR,
    "sound",
    "codhud",
    "announcer"
)

OUT_FILE = os.path.join(
    SCRIPT_DIR,
    "codhud_subtitles.properties"
)


def natural_sort_key(s):
    return [
        int(text) if text.isdigit() else text.lower()
        for text in re.split(r"(\d+)", s)
    ]


def main():
    if not os.path.isdir(ROOT):
        print(f"Folder does not exist: {ROOT}")
        return

    grouped_entries = defaultdict(lambda: defaultdict(list))

    for dirpath, _, filenames in os.walk(ROOT):
        for filename in filenames:
            if not filename.lower().endswith((".wav", ".mp3")):
                continue

            full_path = os.path.join(dirpath, filename)

            rel_path = os.path.relpath(
                full_path,
                ROOT
            ).replace("\\", "/")

            parts = rel_path.split("/")

            #
            # Expected:
            # <game>/en/<team>/<voiceline>.wav
            #
            if len(parts) < 4:
                continue

            game = parts[0].lower()
            language = parts[1].lower()
            team = parts[2].lower()

            # Skip non-English folders if desired
            if language != "en":
                continue

            # Always use the actual filename, regardless of
            # whether there are extra folders like mpvoice
            voiceline = os.path.splitext(parts[-1])[0].lower()

            key = f"CoDHUD.Sub.{game}.{team}.{voiceline}"

            grouped_entries[game][team].append(key)

    with open(OUT_FILE, "w", encoding="utf-8") as f:

        for game in sorted(grouped_entries.keys(), key=natural_sort_key):

            f.write(f"#---------- {game.upper()}\n")

            for team in sorted(
                grouped_entries[game].keys(),
                key=natural_sort_key
            ):

                f.write(f"#------ {team}\n")

                for key in sorted(
                    grouped_entries[game][team],
                    key=natural_sort_key
                ):
                    f.write(f"{key}= \n")

                f.write("\n")

            f.write("\n")

    print(f"Written {OUT_FILE}")


if __name__ == "__main__":
    main()