#!/bin/bash

# Detect platform
PLATFORM=$(uname -m)
if [ "$PLATFORM" = "x86_64" ]; then
	DOCKER_PLATFORM="linux/amd64"
	TARGETARCH="amd64"
elif [ "$PLATFORM" = "aarch64" ]; then
	DOCKER_PLATFORM="linux/arm64"
	TARGETARCH="arm64"
elif [ "$PLATFORM" = "arm64" ]; then
	DOCKER_PLATFORM="linux/arm64"
	TARGETARCH="arm64"
else
	echo "Unsupported platform: $PLATFORM"
	exit 1
fi

echo "DOCKER_PLATFORM=$DOCKER_PLATFORM"
echo "TARGETARCH=$TARGETARCH"

docker build \
	--platform "$DOCKER_PLATFORM" \
	--build-arg TARGETARCH="$TARGETARCH" \
	--build-arg BUILD_DATETIME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
	-t ops-shell .
