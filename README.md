# Docker UWSGI

A very easy-to-use image maker for Python WSGI applications to run in UWSGI.


You can really do anything you want with this, but the way I see it, you want your WSGI application installed in the image, and uwsgi configured to use it via the environment.

## Step 1: Create an image with your application

### Applications on pypi

If your application is on a Python repository, like pypi, just create an image like this:

```
docker build -t my_wsgi_app --build-arg PKG=my_wsgi_app <<-DOCKERFILE
FROM kojiromike/uwsgi
ENV UWSGI_MODULE=my_wsgi_app.module:function \
    UWSGI_HTTP=:8080
```


## Motivation

Separate the concerns of installing, configurating and running the WSGI engine from the concerns of installing the Python WSGI application to be run.
