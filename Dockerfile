##
# The `portage` image provides the package repository.
FROM gentoo/portage as portage


##
# The `system` image is minimal.
FROM gentoo/stage3 as system
LABEL author="Michael A. Smith <michael@smith-li.com>"
LABEL license="Apache License 2.0"
WORKDIR /srv
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo
COPY etc/portage/make.conf /etc/portage/make.conf
ARG PYTHON_VERSION=3.9
RUN echo "PYTHON_SINGLE_TARGET=python${PYTHON_VERSION//./_}" >> /etc/portage/make.conf \
 && echo "PYTHON_TARGETS=python${PYTHON_VERSION//./_}" >> /etc/portage/make.conf \
 && emerge --verbose --info > /etc/emerge-info.log \
 && emerge --changed-use \
           --complete-graph=y \
           --newuse \
           --update \
           --with-bdeps=y \
           --exclude glibc \
           @world \
 && emerge "dev-lang/python:$PYTHON_VERSION" \
 && rm -rf /var/cache/distfiles/ \
 && useradd user \
 && chown -R user:user /srv


##
# The `service` image is for actual use.
FROM system as service
COPY etc/portage/package.accept_keywords /etc/portage/package.accept_keywords
COPY etc/portage/package.use /etc/portage/package.use
RUN emerge dev-python/pip \
           dev-vcs/git \
           www-servers/uwsgi
COPY --chown=user:user etc/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
RUN echo "plugin = python${PYTHON_VERSION//./}" >> /etc/uwsgi/uwsgi.ini
ENV PIP_NO_CACHE_DIR=off \
    PIP_USER=1 \
    UWSGI_INI=/etc/uwsgi/uwsgi.ini \
    UWSGI_MODULE=hello
# Make UWSGI available over http port 8080
EXPOSE 8080/tcp
COPY entrypoint.py /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.py"]
USER user
COPY --chown=user:user hello.* /srv/
