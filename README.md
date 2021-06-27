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

#### Werkzeug Example

[Werkzeug](https://palletsprojects.com/p/werkzeug/) ships with a test application we can use to show how easy it is to add your own.

```
$ docker build -t werkzeug_testapp <<-DOCKERFILE
FROM kojiromike/uwsgi
RUN pip install werkzeug
ENV UWSGI_MODULE=werkzeug.testapp:test_app
DOCKERFILE
$ docker run --name werkzeug_testapp -p 8080:8080 werkzeug_testapp
```


## Motivation

Separate the concerns of installing, configurating and running the WSGI engine from the concerns of installing the Python WSGI application to be run.
