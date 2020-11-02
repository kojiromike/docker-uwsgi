#!/usr/bin/env python3


"""Exec uwsgi unless given other explicit instructions."""


import argparse
import os


def _parse_args():
    """Parse command line arguments and share the right ones with uwsgi."""
    parser = argparse.ArgumentParser('Entrypoint for starting up uwsgi.')
    return parser.parse_known_args()


def main():
    """Determine if we should start uwsgi or do some other instructions."""
    args, unknown_args  = _parse_args()
    if unknown_args:
        os.execvp(unknown_args[0], unknown_args)

    # Why hack this to provide command-line arguments to uwsgi,
    # when you can configure uwsgi every which way from the environment.

    # Don't like the environment? Use a config file.
    os.execlp("uwsgi", "uwsgi")


if __name__ == "__main__":
    main()
