FROM python:3-slim as base

LABEL author="Michael A. Smith <michael@smith-li.com>"
LABEL license="Apache License 2.0"

WORKDIR /whl

ENV PIP_FIND_LINKS=/whl \
    PIP_NO_CACHE_DIR=off \
    PIP_WHEEL_DIR=/whl

RUN python3 -m pip install --upgrade pip setuptools


##
# We don't care about layers in the build stage.
# It is only used to build the uwsgi wheel.
FROM base as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
 && apt-get -y install build-essential libpcre3-dev
RUN python3 -m pip install wheel
RUN python3 -m pip wheel uwsgi


##
# Ship this image as slim as we can.
FROM base as main

##
# Make UWSGI available over http port 8080
EXPOSE 8080/tcp

WORKDIR /srv

RUN adduser user --gecos user \
                 --disabled-password \
                 --disabled-login \
 && chown -R user:user /srv
USER user

COPY --chown=user:user uwsgi.ini /etc/uwsgi/uwsgi.ini

ENV PATH="/home/user/.local/bin:$PATH" \
    PIP_USER=1 \
    UWSGI_INI=/etc/uwsgi/uwsgi.ini

COPY --from=build /whl/ /whl/
RUN python3 -m pip install --no-index uwsgi

COPY --chown=user:user hello.* /srv/

ENTRYPOINT ["uwsgi"]
