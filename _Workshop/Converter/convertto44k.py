"""
Recursively convert all audio files in the CURRENT DIRECTORY
and all subfolders to 44.1 kHz using ffmpeg.

Requirements:
- Python 3
- ffmpeg installed and available in PATH

Usage:
    python convert_samplerate.py

Optional:
    python convert_samplerate.py --in-place
"""

import argparse
import shutil
import subprocess
from pathlib import Path

# Audio file extensions
AUDIO_EXTENSIONS = {
    ".wav",
    ".mp3",
    ".flac",
    ".aac",
    ".m4a",
    ".ogg",
    ".wma",
    ".aiff",
    ".alac",
    ".opus",
}

TARGET_SAMPLE_RATE = 44100


def ffmpeg_exists():
    return shutil.which("ffmpeg") is not None


def convert_file(input_path: Path, in_place: bool):
    # Safer temp filename
    temp_output = input_path.parent / f"{input_path.stem}__converted{input_path.suffix}"

    if not in_place:
        temp_output = input_path.parent / f"{input_path.stem}_44k{input_path.suffix}"

    cmd = [
        "ffmpeg",
        "-y",
        "-i",
        str(input_path),
        "-ar",
        str(TARGET_SAMPLE_RATE),
        str(temp_output),
    ]

    try:
        subprocess.run(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )

        if in_place:
            # Remove readonly flag if present
            input_path.chmod(0o666)

            # Delete original
            input_path.unlink()

            # Rename converted file back
            temp_output.rename(input_path)

        print(f"Converted: {input_path}")

    except Exception as e:
        print(f"Failed: {input_path}")
        print(f"Reason: {e}")

        try:
            if temp_output.exists():
                temp_output.unlink()
        except:
            pass
            
      
def main():
    parser = argparse.ArgumentParser(
        description="Convert all audio files in current directory recursively to 44.1 kHz."
    )

    parser.add_argument(
        "--in-place",
        action="store_true",
        help="Overwrite original files",
    )

    args = parser.parse_args()

    root = Path.cwd()

    print(f"Scanning: {root}")

    if not ffmpeg_exists():
        print("ffmpeg is not installed or not in PATH.")
        return

    files = [
        f for f in root.rglob("*")
        if f.is_file() and f.suffix.lower() in AUDIO_EXTENSIONS
    ]

    print(f"Found {len(files)} audio files.")

    for file_path in files:
        convert_file(file_path, args.in_place)

    print("Done.")


if __name__ == "__main__":
    main()