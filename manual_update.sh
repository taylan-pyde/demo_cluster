#!/bin/bash
set -e

REGISTRY_FOR_PUSH="localhost:5001"              # used on host machine
REGISTRY_FOR_DEPLOY="host.minikube.internal:5001"  # used in Kubernetes manifests

IMAGE_NAME="fastapi-notcached"
DEPLOYMENT_NAME="fastapi-app-notcached"
CONTAINER_NAME="fastapi" 

IMAGE_TAG=$(date +%Y%m%d%H%M%S)
IMAGE_NAME="fastapi-notcached"
FULL_IMAGE_PUSH="$REGISTRY_FOR_PUSH/$IMAGE_NAME:$IMAGE_TAG"
FULL_IMAGE_DEPLOY="$REGISTRY_FOR_DEPLOY/$IMAGE_NAME:$IMAGE_TAG"

docker build --no-cache -t "$FULL_IMAGE_PUSH" src/fastapi
docker push "$FULL_IMAGE_PUSH"

kubectl set image deployment/fastapi-app-notcached fastapi=$FULL_IMAGE_DEPLOY
