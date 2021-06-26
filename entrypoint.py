#!/usr/bin/env python3


"""Exec uwsgi unless given other explicit instructions."""


import argparse
import os

UWSGI_ENV_DOCS = "https://uwsgi-docs.readthedocs.io/en/latest/Configuration.html#environment-variables"

def _parse_args():
    """Parse command line arguments and share the right ones with uwsgi."""
    parser = argparse.ArgumentParser('Entrypoint for starting up uwsgi.')
    return parser.parse_known_args()


def main():
    """Determine if we should start uwsgi or do some other instructions."""
    args, unknown_args  = _parse_args()
    if unknown_args:
        print(f"Received arguments {unknown_args}")
        os.execvp(unknown_args[0], unknown_args)

    print("Starting uwsgi.")
    print(f"Configure uwsgi by setting environment variables or provide a config file: {UWSGI_ENV_DOCS}")
    os.execlp("uwsgi", "uwsgi")


if __name__ == "__main__":
    main()
