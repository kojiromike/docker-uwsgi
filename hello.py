#!/usr/bin/env python3

"""A short application to see if uwsgi is working."""

import os

def application(env, start_response):
    with open('hello.html', 'r') as doc:
        response = doc.read().format(container_name=os.getenv('HOSTNAME'))
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [response.encode('utf-8')]
