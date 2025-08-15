#!/bin/bash

# Social Media App Kubernetes Cleanup Script

set -e

echo "🧹 Starting Social Media App Cleanup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Remove all Kubernetes resources
print_status "Removing Kubernetes resources..."

kubectl delete -f k8s/hpa.yaml --ignore-not-found=true
kubectl delete -f k8s/ingress.yaml --ignore-not-found=true
kubectl delete -f k8s/client.yaml --ignore-not-found=true
kubectl delete -f k8s/socket.yaml --ignore-not-found=true
kubectl delete -f k8s/server.yaml --ignore-not-found=true
kubectl delete -f k8s/mongodb.yaml --ignore-not-found=true
kubectl delete -f k8s/persistent-volumes.yaml --ignore-not-found=true
kubectl delete -f k8s/configmap.yaml --ignore-not-found=true
kubectl delete -f k8s/secrets.yaml --ignore-not-found=true
kubectl delete -f k8s/namespace.yaml --ignore-not-found=true

print_status "Kubernetes resources removed!"

# Optional: Remove Docker images
read -p "Do you want to remove Docker images as well? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Removing Docker images..."
    docker rmi socialmedia-client:latest --force 2>/dev/null || true
    docker rmi socialmedia-server:latest --force 2>/dev/null || true
    docker rmi socialmedia-socket:latest --force 2>/dev/null || true
    print_status "Docker images removed!"
fi

print_status "Cleanup completed successfully!"
echo "🎉 Social Media App cleanup finished!"
