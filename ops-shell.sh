#!/bin/bash

# Check if --no-init flag is provided
NO_INIT=""
if [ "$1" = "--no-init" ]; then
    NO_INIT="--no-init"
    shift
fi

# Check if the Docker image exists
if ! docker image inspect ops-shell >/dev/null 2>&1; then
    echo "Docker image 'ops-shell' not found. Building..."
    if [ -f "./build.sh" ]; then
        ./build.sh
    else
        echo "Error: build.sh not found"
        exit 1
    fi
fi

docker run --rm -it \
  -v "$(pwd)":/workspace \
  ops-shell $NO_INIT "$@"

##-v ./runtime-init.sh:/runtime-init.sh \
