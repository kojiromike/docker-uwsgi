# Docker UWSGI

A very easy-to-use image maker for Python WSGI applications to run in UWSGI.
Provide your own configuration either in the environment or by mounting a file at `/etc/uwsgi/uwsgi.ini`

## Run it!

```
docker run -p 8080:8080 kojiromike/uwsgi
```

Then open http://localhost:8080 in your browser.


## Create an image with your application

### Applications on pypi

If your application is on a Python repository, like pypi, just create an image like this:

```
docker build -t my_wsgi_app <<-DOCKERFILE
FROM kojiromike/uwsgi
RUN pip install my_wsgi_app
ENV UWSGI_MODULE=my_wsgi_app.module:function
DOCKERFILE
```


## Motivation

Separate the concerns of installing, configurating and running the WSGI engine from the concerns of installing the Python WSGI application to be run.
