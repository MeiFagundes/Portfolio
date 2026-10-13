#!/usr/bin/env python3
"""Copy static portfolio demos into Flutter's web output before deployment."""

import shutil
import argparse
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STATIC = ROOT / "hosting/static"
def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="build/web")
    output_path = Path(parser.parse_args().output)
    if not output_path.is_absolute():
        output_path = ROOT / output_path

    if not output_path.is_dir():
        raise SystemExit(f"Flutter web output was not found: {output_path}")
    for source in sorted(STATIC.iterdir()):
        if source.name == ".DS_Store":
            continue
        destination = output_path / source.name
        if source.is_dir():
            shutil.copytree(
                source,
                destination,
                dirs_exist_ok=True,
                ignore=shutil.ignore_patterns(".DS_Store"),
            )
        elif source.is_file():
            shutil.copy2(source, destination)


if __name__ == "__main__":
    main()
