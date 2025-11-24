# 🧊 Amazon Q + Kind Kubernetes Chat App

This project demonstrates how to use **Amazon Q CLI** together with the **kubernetes-mcp-server** to automate Kubernetes tasks using natural language.  
With simple prompts, you can:

- Create a local **Kind** Kubernetes cluster  
- Deploy a complete **chat application** (Frontend + Backend + MongoDB with PV/PVC)  
- Expose it via **Ingress** at: **http://chat.local.com**

---

## 🏗️ Architecture Overview

### **Cluster**
- Kind cluster: `chatapp-cluster`
- Nodes:
  - 1 × control-plane  
  - 2 × worker nodes  

### **Namespace**
- `chat-app`

### **Components**
| Component | Image | Port | Replicas | Service |
|----------|--------|-------|-----------|-----------|
| Frontend | `ganeshkhaire14/chatapp-frontend:latest` | 80 | 2 | `frontend-service` |
| Backend | `ganeshkhaire14/chatapp-backend:latest` | 5001 | 2 | `backend-service` |
| MongoDB | `mongo` | 27017 | 1 | `mongodb-service` |

### **Storage**
- PersistentVolume: 5Gi  
- PersistentVolumeClaim: 5Gi  
- MongoDB mount path: `/data`

### **Security**
- Secret: `jwt-secret`  
  - Key: `JWT_SECRET`

### **Ingress**
- Host: **chat.local.com**
- Routes:
  - `/` → Frontend
  - `/api` → Backend  
- Local DNS entry:
```
127.0.0.1 chat.local.com
```

---

## 🚀 1. Prerequisites

Install the following:

- Linux (Ubuntu recommended)
- Docker
- Kind
- kubectl
- Amazon Q CLI
- kubernetes-mcp-server (through `mcp.json` config)
- A running ingress controller (e.g. ingress-nginx)

---

## 🚀 2. Install Amazon Q CLI

```bash
sudo apt update
sudo apt install -y libfuse2

curl --proto '=https' --tlsv1.2 -sSf https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb -o amazon-q.deb

sudo apt install -y ./amazon-q.deb

q login   # Login using Builder ID (free)
```

Start Amazon Q:

```bash
q
```

---

## 🚀 3. Configure Kubernetes MCP Server

```bash
sudo snap install astral-uv --classic

mkdir -p ~/.aws/amazonq
cd ~/.aws/amazonq
vim mcp.json
```

Paste:

```json
{
  "mcpServers": {
    "kubernetes-mcp-server": {
      "command": "uvx",
      "args": ["kubernetes-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    }
  }
}
```

Restart Q:

```bash
q
```

---

## 🚀 4. Create the Kubernetes Cluster (Using Amazon Q)

Prompt:

```
Create a Kind Kubernetes cluster named chatapp-cluster with 1 control plane node and 2 worker nodes.
Generate a kind-config.yaml file in the current directory and create the cluster.
Then run kubectl get nodes -o wide.
```

---

## 🚀 5. Deploy the Chat App (Using Amazon Q)

Prompt:

Create a Kubernetes namespace chat-app and deploy a frontend with 2 replicas using image ganeshkhaire14/chat-app-frontend-mcp:v2 on container port 80 with a service, a backend using image ganeshkhaire14/chatapp-backend:latest on port 5001 with a service, a MongoDB deployment with a 5Gi PV and PVC and a service, create a secret for JWT,```
Save manifests in k8s/ folder and apply them.
Show kubectl get pods and kubectl get svc in chat-app namespace.
```

---

## 🚀 6. Configure Ingress

Prompt:

```
Create an Ingress named chat-local-ingress with host chat.local.com routing "/" to frontend and "/api" to backend.
Update /etc/hosts with 127.0.0.1 chat.local.com.
Verify with curl.
```

---

## 🌐 7. Access the Application

```
http://chat.local.com
```

---

## 🛠️ 8. Useful Commands

```bash
kubectl get all -n chat-app
kubectl get ingress -n chat-app
kubectl logs -l app=backend -n chat-app
```

---

## 🧹 9. Cleanup

```bash
kubectl delete ns chat-app
kind delete cluster --name chatapp-cluster
```

---

## 📚 Additional Resources

- [Amazon Q CLI Documentation](https://docs.aws.amazon.com/amazonq/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes MCP Server](https://github.com/containers/kubernetes-mcp-server)

---
