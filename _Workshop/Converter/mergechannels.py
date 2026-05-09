import subprocess
from pathlib import Path

# Folder setup
INPUT_DIR = Path("./input_audio")
OUTPUT_DIR = Path("./output_audio")

# Audio formats
EXTENSIONS = {
    ".wav",
    ".mp3",
    ".flac",
    ".m4a",
    ".aac",
    ".ogg",
}

# ffmpeg executable beside script
FFMPEG = Path(__file__).parent / "ffmpeg.exe"


def process_file(input_path: Path):
    relative_path = input_path.relative_to(INPUT_DIR)
    output_path = OUTPUT_DIR / relative_path

    output_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"Processing: {input_path}")

    cmd = [
        str(FFMPEG),
        "-y",
        "-i",
        str(input_path),

        # Merge stereo to mono
        "-ac",
        "1",

        str(output_path),
    ]

    subprocess.run(
        cmd,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=True,
    )

    print(f"Saved: {output_path}")


for file_path in INPUT_DIR.rglob("*"):
    if file_path.is_file() and file_path.suffix.lower() in EXTENSIONS:
        try:
            process_file(file_path)
        except Exception as e:
            print(f"Failed: {file_path}")
            print(e)

print("Done.")