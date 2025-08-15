#!/bin/bash

# Social Media App Kubernetes Deployment Script

set -e

echo "🚀 Starting Social Media App Deployment..."

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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

# Build Docker images
print_status "Building Docker images..."

print_status "Building client image..."
docker build -t socialmedia-client:latest ./client

print_status "Building server image..."
docker build -t socialmedia-server:latest ./server

print_status "Building socket image..."
docker build -t socialmedia-socket:latest ./socket

print_status "Docker images built successfully!"

# Apply Kubernetes configurations
print_status "Applying Kubernetes configurations..."

# Create namespace first
kubectl apply -f k8s/namespace.yaml

# Apply secrets and configs
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/configmap.yaml

# Apply persistent volumes
kubectl apply -f k8s/persistent-volumes.yaml

# Apply services in order
print_status "Deploying MongoDB..."
kubectl apply -f k8s/mongodb.yaml

# Wait for MongoDB to be ready
print_status "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb -n socialmedia --timeout=300s

print_status "Deploying Server..."
kubectl apply -f k8s/server.yaml

# Wait for server to be ready
print_status "Waiting for Server to be ready..."
kubectl wait --for=condition=ready pod -l app=server -n socialmedia --timeout=300s

print_status "Deploying Socket service..."
kubectl apply -f k8s/socket.yaml

print_status "Deploying Client..."
kubectl apply -f k8s/client.yaml

# Apply ingress and HPA
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

print_status "Deployment completed successfully!"

# Display status
print_status "Getting pod status..."
kubectl get pods -n socialmedia

print_status "Getting service status..."
kubectl get services -n socialmedia

print_warning "Add '127.0.0.1 socialmedia.local' to your /etc/hosts file to access the application."
print_status "Access the application at: http://socialmedia.local"

echo "🎉 Social Media App deployed successfully!"
