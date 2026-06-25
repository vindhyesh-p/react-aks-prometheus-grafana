React Application Deployment on AKS with Terraform, ACR, Prometheus & Grafana
Project Overview

This project demonstrates an end-to-end deployment of a React application on Azure Kubernetes Service (AKS) using Docker, Azure Container Registry (ACR), Terraform, Prometheus, and Grafana.

The project covers:

Containerizing a React application using Docker
Provisioning Azure infrastructure using Terraform
Creating and managing Azure Container Registry (ACR)
Deploying containers to Azure Kubernetes Service (AKS)
Exposing the application using Kubernetes Services
Monitoring Kubernetes workloads using Prometheus
Visualizing metrics through Grafana dashboards
Architecture
React + Vite Application
          │
          ▼
      Docker Image
          │
          ▼
Azure Container Registry (ACR)
          │
          ▼
Azure Kubernetes Service (AKS)
          │
          ▼
Kubernetes Deployment
          │
          ▼
Kubernetes Service (LoadBalancer)
          │
          ▼
Application Access

Monitoring Stack

Node Exporter
      │
      ▼
Prometheus
      │
      ▼
Grafana
Technology Stack
Frontend
React
TypeScript
Vite
Containerization
Docker
Nginx
Cloud
Microsoft Azure
Azure Container Registry (ACR)
Azure Kubernetes Service (AKS)
Infrastructure as Code
Terraform
Monitoring
Prometheus
Grafana
kube-state-metrics
Node Exporter
Project Structure
project-root/
│
├── src/
├── public/
│
├── infra/
│   ├── provider.tf
│   └── main.tf
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── Dockerfile
├── package.json
├── README.md
└── .gitignore
Prerequisites

Install the following tools:

Docker Desktop
Azure CLI
Terraform
kubectl
Helm
Git

Verify installation:

docker --version
az --version
terraform --version
kubectl version --client
helm version
git --version
Step 1: Run Application Locally

Install dependencies:

npm install

Run application:

npm run dev

Open:

http://localhost:5173
Step 2: Build Production Artifacts
npm run build

This generates:

dist/

which contains optimized production files.

Step 3: Dockerize the Application

Dockerfile:

FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]

Build image:

docker build -t heart-felt:v1 .

Run locally:

docker run -d -p 8080:80 heart-felt:v1

Open:

http://localhost:8080
Step 4: Provision Infrastructure using Terraform

Initialize Terraform:

terraform init

Preview changes:

terraform plan

Deploy infrastructure:

terraform apply

Resources created:

Resource Group
Azure Container Registry (ACR)
Azure Kubernetes Service (AKS)
Step 5: Push Docker Image to ACR

Login:

az acr login --name <acr-name>

Tag image:

docker tag heart-felt:v1 <acr-name>.azurecr.io/heart-felt:v1

Push image:

docker push <acr-name>.azurecr.io/heart-felt:v1

Verify repository:

az acr repository list --name <acr-name> --output table
Step 6: Connect to AKS

Fetch credentials:

az aks get-credentials \
--resource-group <resource-group> \
--name <aks-name>

Verify:

kubectl get nodes
Step 7: Deploy Application

Deploy:

kubectl apply -f deployment.yaml

Verify:

kubectl get deployments
kubectl get pods
Step 8: Expose Application

Create service:

kubectl apply -f service.yaml

Get external IP:

kubectl get svc

Access application using:

http://<external-ip>
Step 9: Install Monitoring Stack

Add Helm repository:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

Install monitoring stack:

helm install monitoring prometheus-community/kube-prometheus-stack \
--namespace monitoring \
--create-namespace

Verify:

kubectl get pods -n monitoring
Step 10: Access Grafana

Get admin password:

kubectl get secret monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-password}"

Port forward:

kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring

Open:

http://localhost:3000

Login:

Username: admin
Password: <decoded-password>
Monitoring Dashboards

Available dashboards:

Kubernetes Cluster Monitoring
Node Monitoring
Pod Monitoring
CPU Usage
Memory Usage
Network Usage
Container Health
