#!/bin/bash

VERSION=$(cat VERSION)
DOCKER_REPOS="vfabi/open-ports-scanner"
DOCKER_TAGS="$VERSION latest"
PLATFORMS="linux/amd64,linux/arm64"
DOCKERFILE="Dockerfile"


# Patch Dockerfile
sed -r -i 's/APP_VERSION=(\b[0-9]{1,2}\.){2}[0-9]{1,2}\b'/"APP_VERSION=$VERSION"/ $DOCKERFILE

# Build docker image
for docker_repo in $DOCKER_REPOS;
do
    for docker_tag in $DOCKER_TAGS;
    do
        echo -e "Building image $docker_repo:$docker_tag ($PLATFORMS)\n"
        docker buildx build --push --platform=$PLATFORMS -t $docker_repo:$docker_tag -f $DOCKERFILE .
    done
done
