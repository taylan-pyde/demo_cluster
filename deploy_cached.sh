#!/bin/bash
set -e

# Registry config
REGISTRY_FOR_PUSH="localhost:5001"
REGISTRY_FOR_DEPLOY="host.minikube.internal:5001"

# Deployment/ImageCache/Container names
IMAGE_NAME="fastapi"
DEPLOYMENT_NAME="fastapi-app"
CONTAINER_NAME="fastapi"
IMAGECACHE_NAME="fastapi-app"

# Generate unique tag
IMAGE_TAG=$(date +%Y%m%d%H%M%S)
FULL_IMAGE_PUSH="$REGISTRY_FOR_PUSH/$IMAGE_NAME:$IMAGE_TAG"
FULL_IMAGE_DEPLOY="$REGISTRY_FOR_DEPLOY/$IMAGE_NAME:$IMAGE_TAG"

# Build and push
echo "🔨 Building image: $FULL_IMAGE_PUSH"
docker build -t "$FULL_IMAGE_PUSH" src/fastapi

echo "📦 Pushing image to local registry"
docker push "$FULL_IMAGE_PUSH"

# Patch ImageCache to preload this image
echo "🧊 Patching kube-fledged ImageCache"
kubectl patch imagecache "$IMAGECACHE_NAME" --type='json' -p="[
  {
    \"op\": \"replace\",
    \"path\": \"/spec/cacheSpec/images/0\",
    \"value\": \"$FULL_IMAGE_DEPLOY\"
  }
]"

# Trigger refresh
echo "🔁 Triggering image refresh"
kubectl annotate imagecache "$IMAGECACHE_NAME" \
  kube-fledged.io/refresh-request-timestamp="$(date +%s)" --overwrite

# Wait for kube-fledged to cache the image (optional, fast images may finish before deploy)
echo "⏳ Waiting for image to be cached..."
while true; do
  STATUS=$(kubectl get imagecache "$IMAGECACHE_NAME" -o jsonpath='{.status.nodes.minikube.cacheStatus}')
  echo "   ➤ Current status: $STATUS"
  [ "$STATUS" == "ImagePresent" ] && break
  sleep 2
done

# Update deployment to use the new image
echo "🚀 Updating deployment image"
kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$FULL_IMAGE_DEPLOY --record

echo "✅ Cached deployment updated with image: $FULL_IMAGE_DEPLOY"
