#!/bin/bash
set -e

REGISTRY_FOR_PUSH="localhost:5001"              # used on host machine
REGISTRY_FOR_DEPLOY="host.minikube.internal:5001"  # used in Kubernetes manifests

IMAGE_NAME="fastapi"
DEPLOYMENT_NAME="fastapi-app"
CONTAINER_NAME="fastapi"
CACHE_NAME="image-cache"

IMAGE_TAG=$(date +%Y%m%d%H%M%S)
IMAGE_NAME="fastapi"
FULL_IMAGE_PUSH="$REGISTRY_FOR_PUSH/$IMAGE_NAME:$IMAGE_TAG"
FULL_IMAGE_DEPLOY="$REGISTRY_FOR_DEPLOY/$IMAGE_NAME:$IMAGE_TAG"

docker build --no-cache -t "$FULL_IMAGE_PUSH" src/fastapi
docker push "$FULL_IMAGE_PUSH"

kubectl patch imagecache image-cache -n kube-fledged \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/cacheSpec/0/images", "value": ["'"$FULL_IMAGE_DEPLOY"'"]}]'


kubectl annotate imagecaches $CACHE_NAME -n kube-fledged kubefledged.io/refresh-imagecache=

kubectl set image deployment/fastapi-app fastapi=$FULL_IMAGE_DEPLOY
