#!/usr/bin/env python3


"""Exec uwsgi unless given other explicit instructions."""

import argparse
import os
import subprocess
from pathlib import Path


UWSGI_CONFIG_DOCS = "https://uwsgi-docs.readthedocs.io/en/latest/Configuration.html"

def _parse_args():
    """Parse command line arguments and share the right ones with uwsgi."""
    parser = argparse.ArgumentParser("Entrypoint for starting up uwsgi.")
    return parser.parse_known_args()


def main():
    """Determine if we should start uwsgi or do some other instructions."""
    args, unknown_args  = _parse_args()
    if unknown_args and not unknown_args[0].startswith("-"):
        print(f"Received arguments {unknown_args}")
        os.execvp(unknown_args[0], unknown_args)

    packages = os.getenv("PYPI_PACKAGES") or ""
    requirements = ["--requirement", "/srv/requirements.txt"] if Path("/srv/requirements.txt").exists() else []
    if packages or requirements:
        print("Installing additional requirements")
        subprocess.run(["pip", "install"] + requirements + packages.split())

    print("Starting uwsgi.")
    print(f"Configure uwsgi by setting environment variables, provide a config file, or add command-line options: {UWSGI_CONFIG_DOCS}")
    os.execlp("uwsgi", "uwsgi", *unknown_args)


if __name__ == "__main__":
    main()
