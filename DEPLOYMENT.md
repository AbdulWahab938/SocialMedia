# Deployment Guide - Social Media Clone

This guide provides detailed instructions for deploying the Social Media Clone application in various environments.

## Table of Contents
1. [Local Development](#local-development)
2. [Docker Deployment](#docker-deployment)
3. [Kubernetes Deployment](#kubernetes-deployment)
4. [Production Considerations](#production-considerations)
5. [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)

## Local Development

### Quick Start
```bash
# Clone the repository
git clone https://github.com/AbdulWahab938/SocialMedia.git
cd SocialMedia

# Install dependencies for all services
cd client && npm install && cd ..
cd server && npm install && cd ..
cd socket && npm install && cd ..

# Start MongoDB (ensure it's running on localhost:27017)
# Start all services in separate terminals:
cd server && npm start
cd socket && npm start  
cd client && npm start
```

## Docker Deployment

### Using Docker Compose (Recommended)

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Clean up volumes (WARNING: This will delete all data)
docker-compose down -v
```

### Manual Docker Deployment

```bash
# Create network
docker network create socialmedia-net

# Start MongoDB
docker run -d --name mongodb \
  --network socialmedia-net \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password123 \
  -v mongodb_data:/data/db \
  mongo:6.0

# Build and run server
docker build -t socialmedia-server ./server
docker run -d --name server \
  --network socialmedia-net \
  -p 5000:5000 \
  -e MONGODB_CONNECTION=mongodb://admin:password123@mongodb:27017/socialmedia?authSource=admin \
  -e JWTKEY=your_jwt_secret \
  socialmedia-server

# Build and run socket
docker build -t socialmedia-socket ./socket
docker run -d --name socket \
  --network socialmedia-net \
  -p 8800:8800 \
  socialmedia-socket

# Build and run client
docker build -t socialmedia-client ./client
docker run -d --name client \
  --network socialmedia-net \
  -p 3000:80 \
  socialmedia-client
```

## Kubernetes Deployment

### Prerequisites

1. **Kubernetes Cluster**
   - Local: Minikube, Docker Desktop, or Kind
   - Cloud: GKE, EKS, AKS, or DigitalOcean

2. **Tools Required**
   - kubectl
   - Docker
   - Helm (optional, for package management)

### Quick Deployment

```bash
# Run the automated deployment script
./deploy.sh

# Check deployment status
kubectl get pods -n socialmedia
kubectl get services -n socialmedia
kubectl get ingress -n socialmedia

# Access the application
echo "127.0.0.1 socialmedia.local" | sudo tee -a /etc/hosts
open http://socialmedia.local
```

### Step-by-Step Deployment

1. **Prepare Docker Images**
```bash
# Build images (if not using registry)
docker build -t socialmedia-client:latest ./client
docker build -t socialmedia-server:latest ./server  
docker build -t socialmedia-socket:latest ./socket

# For production, push to registry:
# docker tag socialmedia-client:latest your-registry/socialmedia-client:v1.0
# docker push your-registry/socialmedia-client:v1.0
```

2. **Deploy Infrastructure**
```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Apply secrets (update with your values first!)
kubectl apply -f k8s/secrets.yaml

# Apply configurations
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/persistent-volumes.yaml
```

3. **Deploy Database**
```bash
kubectl apply -f k8s/mongodb.yaml

# Wait for MongoDB to be ready
kubectl wait --for=condition=ready pod -l app=mongodb -n socialmedia --timeout=300s
```

4. **Deploy Application Services**
```bash
kubectl apply -f k8s/server.yaml
kubectl apply -f k8s/socket.yaml
kubectl apply -f k8s/client.yaml

# Wait for services to be ready
kubectl wait --for=condition=ready pod -l app=server -n socialmedia --timeout=300s
```

5. **Setup Ingress and Scaling**
```bash
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml
```

### Cleanup

```bash
# Use cleanup script
./cleanup.sh

# Or manually:
kubectl delete namespace socialmedia
```

## Production Considerations

### Security

1. **Update Secrets**
```bash
# Generate strong passwords
kubectl create secret generic socialmedia-secrets \
  --from-literal=mongodb-username=admin \
  --from-literal=mongodb-password=$(openssl rand -base64 32) \
  --from-literal=jwt-key=$(openssl rand -base64 64) \
  -n socialmedia
```

2. **Enable TLS**
```bash
# Install cert-manager for automatic SSL
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml

# Configure certificate issuer (update with your email)
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@domain.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

3. **Network Policies**
```bash
# Apply network policies to restrict traffic
kubectl apply -f k8s/network-policies.yaml
```

### High Availability

1. **Multi-AZ Deployment**
- Deploy across multiple availability zones
- Use node affinity and anti-affinity rules
- Configure pod disruption budgets

2. **Database High Availability**
```bash
# For production, use MongoDB replica set or managed service
# MongoDB Atlas, Google Cloud MongoDB, etc.
```

3. **Monitoring**
```bash
# Install Prometheus and Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

### Performance Optimization

1. **Resource Tuning**
- Monitor CPU and memory usage
- Adjust resource requests/limits
- Configure HPA thresholds

2. **Caching**
- Implement Redis for session caching
- Use CDN for static assets
- Enable browser caching

3. **Database Optimization**
- Create proper indexes
- Monitor query performance
- Consider read replicas

## Monitoring and Troubleshooting

### Health Checks

```bash
# Check pod status
kubectl get pods -n socialmedia

# Check pod logs
kubectl logs -f deployment/server -n socialmedia
kubectl logs -f deployment/client -n socialmedia
kubectl logs -f deployment/socket -n socialmedia

# Check service endpoints
kubectl get endpoints -n socialmedia

# Test connectivity
kubectl exec -it deployment/server -n socialmedia -- curl http://mongodb-service:27017
```

### Common Issues

1. **Image Pull Issues**
```bash
# Check if images exist
docker images | grep socialmedia

# For minikube, load images:
minikube image load socialmedia-client:latest
minikube image load socialmedia-server:latest
minikube image load socialmedia-socket:latest
```

2. **Persistent Volume Issues**
```bash
# Check PV/PVC status
kubectl get pv,pvc -n socialmedia

# For minikube, enable addons:
minikube addons enable default-storageclass
minikube addons enable storage-provisioner
```

3. **Service Discovery Issues**
```bash
# Check DNS resolution
kubectl exec -it deployment/server -n socialmedia -- nslookup mongodb-service
kubectl exec -it deployment/server -n socialmedia -- nslookup socket-service
```

4. **Ingress Issues**
```bash
# Check ingress status
kubectl get ingress -n socialmedia
kubectl describe ingress socialmedia-ingress -n socialmedia

# For minikube, enable ingress:
minikube addons enable ingress
```

### Performance Monitoring

```bash
# Check resource usage
kubectl top pods -n socialmedia
kubectl top nodes

# Check HPA status
kubectl get hpa -n socialmedia

# View events
kubectl get events -n socialmedia --sort-by='.lastTimestamp'
```

### Scaling

```bash
# Manual scaling
kubectl scale deployment server --replicas=5 -n socialmedia
kubectl scale deployment client --replicas=3 -n socialmedia

# View HPA status
kubectl describe hpa server-hpa -n socialmedia
```

## Backup and Disaster Recovery

### Database Backup

```bash
# Create MongoDB backup job
kubectl create job mongodb-backup --from=cronjob/mongodb-backup -n socialmedia

# Manual backup
kubectl exec -it deployment/mongodb -n socialmedia -- mongodump --uri="mongodb://admin:password@localhost:27017/socialmedia?authSource=admin" --out=/backup
```

### Application Configuration Backup

```bash
# Export current configuration
kubectl get all,pv,pvc,secrets,configmap -n socialmedia -o yaml > socialmedia-backup.yaml
```

This deployment guide provides comprehensive instructions for deploying the Social Media Clone in various environments, from local development to production-ready Kubernetes clusters.
