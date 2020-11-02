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
 && apt-get -y install build-essential
RUN python3 -m pip install wheel
RUN python3 -m pip wheel uwsgi


##
# Ship this image as slim as we can.
FROM base as main

RUN adduser user --gecos user \
                 --disabled-password \
                 --disabled-login
ENV PATH="/home/user/.local/bin:$PATH" \
    PIP_USER=1
USER user

COPY --from=build /whl/ /whl/
RUN python3 -m pip install --no-index uwsgi

WORKDIR /srv
COPY entrypoint.py /bin/entrypoint
COPY hello.py /srv/hello.py

ENTRYPOINT ["entrypoint"]

# UWSGI is exposed via port 8080 and /sockets/
EXPOSE 8080/tcp
VOLUME /sockets/

ONBUILD ARG PIP_EXTRA_INDEX_URL
ONBUILD ARG PKG
ONBUILD RUN [ -z "$PKG" ] || python3 -m pip install "$PKG"
