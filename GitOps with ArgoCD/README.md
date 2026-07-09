Our RetailSphere project has now reached the stage where many real companies begin adopting GitOps practices.

# **RetailSphere Enterprise DevOps Project**

**Completed**

✅ Phase 1 – Infrastructure Foundation

✅ Phase 2 – Terraform Infrastructure

✅ Phase 3 – Ansible Configuration Management

✅ Phase 4 – Spring Boot Application Development

✅ Phase 5 – Dockerization

✅ Phase 6 – Kubernetes Deployment

✅ Phase 7 – Jenkins CI/CD

✅ Phase 8 – Helm Packaging \& Deployment

# **Phase 9 – GitOps with ArgoCD**

**Objective**

Implement GitOps methodology using Argo CD.

Instead of Jenkins deploying directly to Kubernetes:

**Current Flow**

```
Developer
   ↓
GitHub
   ↓
Jenkins
   ↓
kubectl apply
   ↓
Kubernetes
```

**GitOps Flow**

```
Developer
   ↓
GitHub
   ↓
ArgoCD
   ↓
Kubernete
```

ArgoCD continuously monitors Git repositories and automatically synchronizes Kubernetes resources when changes are detected.

# **Phase 9 Architecture**

```
GitHub Repository
│
├── app/
├── terraform/
├── ansible/
└── helm/
     └── retailsphere
           ├── Chart.yaml
           ├── values.yaml
           └── templates/
                   ↓
                 ArgoCD
                   ↓
           Kubernetes Cluster
```

# **Phase 9 Deliverables**

## **Phase 9.1**
Install ArgoCD

## **Phase 9.2**
Expose ArgoCD UI

## **Phase 9.3**
Login to ArgoCD

## **Phase 9.4**
Create GitOps Application

## **Phase 9.5**
Deploy RetailSphere via ArgoCD

## **Phase 9.6**
Auto Sync Configuration

## **Phase 9.7**
GitOps Validation

## **Phase 9.8**
Documentation

## **Step 1 — Create Namespace**

On master node:

```bash
kubectl create namespace argocd
```

Verify:

```bash
kubectl get ns
```

Expected:
```bash

argocd
retailsphere
default
kube-system

```

## **Step 2 — Install ArgoCD**

```bash
kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait:

```bash
kubectl get pods -n argocd
```

Expected:

```bash

argocd-server
argocd-repo-server
argocd-application-controller
argocd-dex-server
argocd-redis

```

All should become:

```bash
Running
```

## **Step 3 — Verify Installation**

```bash
kubectl get all -n argocd
```

we should see:

```bash
pods
services
deployments
replicasets
```

## **Step 4 — Expose ArgoCD UI**

Check service:

```bash
kubectl get svc -n argocd
```

Expected:

```bash
argocd-server
ClusterIP
```

Change to NodePort:

```bash
kubectl patch svc argocd-server \
-n argocd \
-p '{"spec":{"type":"NodePort"}}'
```

Verify:

```bash
kubectl get svc -n argocd
```

Example:

```bash
argocd-server NodePort
80:30080/TCP
443:30443/TCP
```

## **Step 5 — Get Initial Admin Password**

```bash
kubectl get secret argocd-initial-admin-secret \
-n argocd \
-o jsonpath="{.data.password}" | base64 -d
```

Save the password.

## **Step 6 — Access ArgoCD**

Open browser:

```
https://<MASTER_PUBLIC_IP>:30443
```

Example:

```
https://13.xx.xx.xx:30443
```

Username:

```
admin
```

Password:

```
<password_from_secret>
```

##### **Step 7 — Verify GitHub Repository**

Current repository:

```
https://github.com/Nadheer18/retailsphere.git
```

ArgoCD will pull Helm chart directly from:

```
helm/retailsphere
```

## **Step 8 — Create GitOps Application**

Later from UI:

Application Name:
```retailsphere```

Project:
```default```

Sync Policy:
```
Manual
```

Repository URL:
```
https://github.com/Nadheer18/retailsphere.git
```

Path:
```
helm/retailsphere
```

Cluster URL:
```
https://kubernetes.default.svc
```

Namespace:
```
retailsphere
```

## **Phase 9 Goal**

At the end of Phase 9:

```
GitHub
  ↓
ArgoCD
  ↓
Kubernetes
```

A git push to your Helm chart will automatically update the RetailSphere deployment in Kubernetes.

## **Before moving to Phase 9.2, execute:**

```
kubectl create namespace argocd

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get pods -n argocd -w
```



Wait until every ArgoCD pod shows Running, then we'll continue with Phase 9.2 – ArgoCD UI Access \& Login.

