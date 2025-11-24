#!/bin/bash
# Deploy Chat Application

echo "Deploying Chat Application..."

# Apply manifests in order
kubectl apply -f namespace.yaml
kubectl apply -f secrets.yaml
kubectl apply -f storage.yaml
kubectl apply -f mongodb.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml
kubectl apply -f ingress.yaml

# Add to hosts file
echo "127.0.0.1 chat.local.com" >> /etc/hosts

echo "Deployment complete! Access at http://chat.local.com"
