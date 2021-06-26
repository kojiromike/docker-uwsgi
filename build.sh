#!/usr/bin/env bash

##
# Build and test the image.


build_image() {
    echo 'Building the uwsgi image'
    docker build -t uwsgi .
}

build_test_image() {
    echo 'Building the uwsgi test image'
    local test_tag
    test_tag="test_$(docker images -q uwsgi:latest)"
    {
        echo 'FROM uwsgi:latest'
        echo 'RUN pip install werkzeug'
        echo 'ENV UWSGI_MODULE=werkzeug.testapp:test_app'
    } | docker build --tag "uwsgi:$test_tag" -
}

run_test_image() {
    echo 'Starting a uwsgi test container'
    local test_tag
    test_tag="test_$(docker images -q uwsgi:latest)"
    docker run --detach --name "uwsgi_$test_tag" -P "uwsgi:$test_tag"
}

test_image() {
    echo 'Testing the uwsgi container'
    local test_tag
    local ports port
    test_tag="test_$(docker images -q uwsgi:latest)"
    ports=$(docker port "uwsgi_$test_tag" 8080)
    port="${ports##*:}"
    if wget -SO/dev/null "http://[::0]:$port" 2>&1 | grep -qF '200 OK'; then
        echo 'Tests passed, removing test container and image.'
        docker rm -f "uwsgi_$test_tag"
        docker rmi "uwsgi:$test_tag"
        exit 0
    fi
    printf 'Tests failed, inspect the container named %s\n' "uwsgi_$test_tag" >&2
    exit 1
}

main() {
    build_image
    build_test_image
    run_test_image
    test_image
}

main "$@"
