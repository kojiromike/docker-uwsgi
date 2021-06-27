#!/usr/bin/env python3

"""A short application to see if uwsgi is working."""

import os
from pathlib import Path


def application(env, start_response):
    response = Path('hello.html').read_text().format(container_name=os.getenv('HOSTNAME'))
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [response.encode('utf-8')]
