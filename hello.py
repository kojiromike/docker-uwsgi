#!/usr/bin/env python3


"""A short application to see if uwsgi is working."""

def application(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b'Hello World']
