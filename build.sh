#!/usr/bin/env bash

##
# Build and test the image.


docker build -t uwsgi .

test_tag="test_$(docker images -q uwsgi:latest)"
docker build --tag "uwsgi:$test_tag" --build-arg PKG=werkzeug - <<< 'FROM uwsgi:latest'

export UWSGI_HTTP=:8080
export UWSGI_MODULE=werkzeug.testapp:test_app
docker run --detach --name "uwsgi_$test_tag" -P -e UWSGI_MODULE -e UWSGI_HTTP "uwsgi:$test_tag"
port=$(docker port "uwsgi_$test_tag" 8080) port="${port#0.0.0.0:}"

if wget -SO/dev/null "http://[::0]:$port" 2>&1 | grep -qF '200 OK'; then
    echo 'Tests passed, removing test container and image.'
    docker rm -f "uwsgi_$test_tag"
    docker rmi "uwsgi:$test_tag"
    exit 0
fi

printf 'Tests failed, inspect the container named %s\n' "uwsgi_$test_tag" >&2
exit 1
