#!/bin/bash

VERSION=$(cat VERSION)
DOCKER_REPOS="vfabi/open-ports-scanner"
DOCKER_TAGS="$VERSION latest"
PLATFORMS="linux/amd64,linux/arm64"
DOCKERFILE="Dockerfile"


# Patch version in files
sed -r -i 's/APP_VERSION=(\b[0-9]{1,2}\.){2}[0-9]{1,2}\b'/"APP_VERSION=$VERSION"/ $DOCKERFILE
sed -r -i 's/(^\s*tag:\s*").*(")$/\1'"$VERSION"'\2/' deploy/kubernetes/helm/values.yaml
sed -r -i 's/(^appVersion:\s*").*(")$/\1'"$VERSION"'\2/' deploy/kubernetes/helm/Chart.yaml
sed -r -i 's|(image:\s*vfabi/open-ports-scanner:).*|\1'"$VERSION"'|' deploy/kubernetes/yaml/main.yaml

# Build docker image
for docker_repo in $DOCKER_REPOS;
do
    for docker_tag in $DOCKER_TAGS;
    do
        echo -e "Building image $docker_repo:$docker_tag ($PLATFORMS)\n"
        docker buildx build --push --platform=$PLATFORMS -t $docker_repo:$docker_tag -f $DOCKERFILE .
    done
done
