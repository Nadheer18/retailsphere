# RetailSphere Enterprise DevOps Project

# **Phase 10.2 – Install Monitoring Stack**

This phase installs the **enterprise Kubernetes monitoring platform** that many production environments use. We'll deploy it with Helm so it's easy to manage, upgrade, and later synchronize with Argo CD.

---

# Phase Objectives

By the end of this phase, your cluster will have:

* ✅ Prometheus
* ✅ Grafana
* ✅ Alertmanager
* ✅ Node Exporter
* ✅ kube-state-metrics
* ✅ Prometheus Operator
* ✅ Persistent Storage
* ✅ Enterprise Helm deployment
* ✅ Ready for GitOps (Phase 9 integration)

---

# Why use kube-prometheus-stack?

Instead of installing each component separately, we'll use the **Prometheus Community `kube-prometheus-stack`** Helm chart because it includes:

| Component           | Included |
| ------------------- | -------- |
| Prometheus          | ✅        |
| Grafana             | ✅        |
| Alertmanager        | ✅        |
| Prometheus Operator | ✅        |
| Node Exporter       | ✅        |
| kube-state-metrics  | ✅        |
| ServiceMonitor CRD  | ✅        |
| PodMonitor CRD      | ✅        |
| PrometheusRule CRD  | ✅        |

This is the standard enterprise deployment approach.

---

# Architecture

```text
                 Kubernetes Cluster
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
 Node Exporter   kube-state-metrics  Spring Boot
        │               │                │
        └───────────────┼────────────────┘
                        │
                 Prometheus Operator
                        │
                 Prometheus Server
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
      Grafana                  Alertmanager
          │                           │
          ▼                           ▼
    Dashboards                 Telegram (Phase 10.8)
```

---

# Step 1 – Verify Helm

On your control plane node:

```bash
helm version
```

Expected output:

```text
version.BuildInfo{
Version:"v3.x.x"
...
}
```

---

# Step 2 – Verify Cluster Health

```bash
kubectl get nodes
```

Expected:

```text
NAME        STATUS   ROLES
master      Ready    control-plane
worker-1    Ready
worker-2    Ready
```

---

# Step 3 – Create Monitoring Namespace

```bash
kubectl create namespace monitoring
```

Verify:

```bash
kubectl get ns
```

Expected:

```text
monitoring
retailsphere
ingress-nginx
argocd
default
```

---

# Step 4 – Add Helm Repository

```bash
helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts
```

Update repositories:

```bash
helm repo update
```

Verify:

```bash
helm search repo kube-prometheus-stack
```

Expected:

```text
prometheus-community/kube-prometheus-stack
```

---

# Step 5 – Create Project Structure

From your project root:

```text
retailsphere/
│
├── monitoring/
│
│   ├── helm-values/
│   │      └── kube-prometheus-stack-values.yaml
│   │
│   ├── dashboards/
│   │
│   ├── alerts/
│   │
│   ├── servicemonitors/
│   │
│   └── README.md
```

Create it:

```bash
mkdir -p monitoring/{helm-values,dashboards,alerts,servicemonitors}
touch monitoring/README.md
touch monitoring/helm-values/kube-prometheus-stack-values.yaml
```

---

# Step 6 – Create Enterprise Values File

File:

```text
monitoring/helm-values/kube-prometheus-stack-values.yaml
```

Initial configuration:

```yaml
grafana:
  adminPassword: admin123

  persistence:
    enabled: true
    size: 5Gi

prometheus:
  prometheusSpec:
    retention: 15d

    storageSpec:
      volumeClaimTemplate:
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 20Gi

alertmanager:
  alertmanagerSpec:
    storage:
      volumeClaimTemplate:
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 2Gi
```

### Why these values?

| Component    | Storage | Reason                       |
| ------------ | ------- | ---------------------------- |
| Prometheus   | 20Gi    | Stores time-series metrics   |
| Grafana      | 5Gi     | Dashboards and configuration |
| Alertmanager | 2Gi     | Alert state and silences     |

For a learning environment, these sizes are sufficient. In production, storage is sized based on retention, scrape interval, and cluster size.

---

# Step 7 – Install Dynamic Storage Provisioner (Local Path Provisioner)

check storageclass
Your output clearly shows:

```text
kubectl get storageclass

No resources found
```

Because your kubeadm cluster **does not have a StorageClass**, Kubernetes cannot dynamically provision Persistent Volumes.

As a result:

* ❌ Prometheus PVC → Pending
* ❌ Grafana PVC → Pending
* ❌ Alertmanager PVC → Pending

Therefore the pods remain **Pending** because they are waiting for storage.

This is **expected** on a self-managed kubeadm cluster. Unlike managed Kubernetes services such as Amazon EKS, self-managed clusters don't include a default storage provisioner.

---

# What Should We Do?

Since RetailSphere is being built with **enterprise best practices**, we have two options.

## Option 1 (Recommended) – Install a Dynamic Storage Provisioner

Examples include:

* Local Path Provisioner (Rancher)
* OpenEBS
* Longhorn
* NFS CSI
* Amazon EBS CSI Driver (for EKS later)

### Pros

* Automatic PV creation
* Production-like experience
* PVCs are created automatically
* GitOps-friendly
* Easier future management

This is the approach I recommend for your learning and future migration.

---

## Option 2 – Create Static PVs Manually

This is what we did earlier for MySQL.

You would create:

* 1 PV for Grafana
* 1 PV for Prometheus
* 1 PV for Alertmanager

### Cons

* Manual management
* Doesn't scale well
* Not how enterprise environments are typically operated

---

# My Recommendation

Since RetailSphere is intended to be an **enterprise portfolio project**, let's install a **dynamic storage provisioner** now.

That way:

* Phase 10 (Monitoring) works smoothly.
* Phase 11 (Logging) will also use persistent storage.
* Phase 13 (Amazon EKS) will transition naturally to the Amazon EBS CSI Driver.

---

# Recommended Provisioner

I recommend **Rancher Local Path Provisioner** because it is:

* Lightweight
* Widely used in labs and development clusters
* Easy to install
* Creates a default `StorageClass`
* Automatically provisions local Persistent Volumes
* Ideal for a kubeadm-based learning environment

---

# Revised Roadmap

Before continuing with Prometheus configuration, we'll insert one additional step:

**Phase 10.2.1 – Dynamic Storage Configuration**

* Install Local Path Provisioner
* Create a default StorageClass
* Verify dynamic provisioning
* Rebind the pending PVCs
* Confirm Prometheus, Grafana, and Alertmanager reach the `Running` state

After that we'll continue with:

* **Phase 10.3 – Configure Prometheus**

This is a cleaner and more maintainable approach than creating three static PVs manually, and it aligns much better with enterprise Kubernetes practices.

---

Perfect. We'll proceed with the enterprise approach.

# RetailSphere Enterprise DevOps Project

# **Phase 10.2.1 – Install Dynamic Storage Provisioner (Local Path Provisioner)**

> **Goal:** Add dynamic storage to your kubeadm cluster so that Prometheus, Grafana, Alertmanager, and future workloads (such as Loki in Phase 11) can automatically provision Persistent Volumes.

---

# Why are we doing this?

Your current situation:

```text
StorageClass : ❌ None
PVC          : Pending
Pods         : Pending
```

We need a **default StorageClass** before continuing.

---

# Architecture

```text
PVC
 │
 ▼
StorageClass (local-path)
 │
 ▼
Local Path Provisioner
 │
 ▼
Host Path on Worker Node
 │
 ▼
Persistent Volume
```

---

# Step 1 – Install Local Path Provisioner

Create a directory for storage-related manifests:

```bash
mkdir -p ~/retailsphere/storage
cd ~/retailsphere/storage
```

Install the provisioner:

```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

Expected output:

```text
namespace/local-path-storage created
serviceaccount/local-path-provisioner-service-account created
clusterrole.rbac.authorization.k8s.io/local-path-provisioner-role created
...
storageclass.storage.k8s.io/local-path created
deployment.apps/local-path-provisioner created
```

---

# Step 2 – Verify Installation

Check the namespace:

```bash
kubectl get ns
```

You should see:

```text
local-path-storage
```

---

Check the pod:

```bash
kubectl get pods -n local-path-storage
```

Expected:

```text
NAME                                      READY   STATUS
local-path-provisioner-xxxxxxxxxx-xxxxx   1/1     Running
```

---

# Step 3 – Verify StorageClass

```bash
kubectl get storageclass
```

Expected:

```text
NAME         PROVISIONER                RECLAIMPOLICY
local-path   rancher.io/local-path      Delete
```

At this point, `local-path` may or may not already be marked as the default (`(default)`), depending on the manifest version.

---

# Step 4 – Make It the Default StorageClass

Check the current annotations:

```bash
kubectl describe storageclass local-path
```

If it is **not** the default, patch it:

```bash
kubectl patch storageclass local-path \
-p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

Verify:

```bash
kubectl get storageclass
```

Expected:

```text
NAME                   PROVISIONER             DEFAULT
local-path (default)   rancher.io/local-path   Yes
```

---

# Step 7 – Install Monitoring Stack

```bash
helm install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring \
-f monitoring/helm-values/kube-prometheus-stack-values.yaml
```

Helm will create:

* Prometheus
* Grafana
* Alertmanager
* Prometheus Operator
* Node Exporter
* kube-state-metrics
* CRDs

---

# Step 8 – Verify Helm Release

```bash
helm list -n monitoring
```

Expected:

```text
NAME         STATUS
monitoring   deployed
```

---

# Step 9 – Verify Pods

```bash
kubectl get pods -n monitoring
```

Typical output:

```text
alertmanager-monitoring-kube-prometheus-alertmanager-0

monitoring-grafana

monitoring-kube-prometheus-operator

monitoring-kube-state-metrics

monitoring-prometheus-node-exporter-xxxxx

prometheus-monitoring-kube-prometheus-prometheus-0
```

All pods should eventually reach the `Running` state.

---

# Step 10 – Verify Services

```bash
kubectl get svc -n monitoring
```

Typical services:

```text
monitoring-grafana

monitoring-kube-prometheus-alertmanager

monitoring-kube-prometheus-prometheus

monitoring-kube-state-metrics
```

---

# Step 11 – Verify StatefulSets

```bash
kubectl get statefulsets -n monitoring
```

Expected:

```text
alertmanager-monitoring-kube-prometheus-alertmanager

prometheus-monitoring-kube-prometheus-prometheus
```

---

# Step 12 – Verify DaemonSets

```bash
kubectl get daemonsets -n monitoring
```

Expected:

```text
monitoring-prometheus-node-exporter
```

Since Node Exporter runs as a DaemonSet, you should see one pod per Kubernetes node.

---

# Step 13 – Verify PVCs

```bash
kubectl get pvc -n monitoring
```

Expected:

```text
storage-prometheus-...

storage-alertmanager-...

storage-monitoring-grafana
```

All PVCs should be in the `Bound` state. If they remain `Pending`, check your StorageClass:

```bash
kubectl get storageclass
```

If your cluster doesn't have a default StorageClass (common in self-managed kubeadm clusters), we'll create one in the next step before proceeding.

---

# Step 14 – Verify CRDs

```bash
kubectl get crd | grep monitoring
```

You'll see CRDs such as:

```text
alertmanagers.monitoring.coreos.com

podmonitors.monitoring.coreos.com

prometheuses.monitoring.coreos.com

prometheusrules.monitoring.coreos.com

servicemonitors.monitoring.coreos.com
```

These custom resources are managed by the Prometheus Operator.

---

# Enterprise Directory Layout

After installation, your repository should look like:

```text
retailsphere/
│
├── monitoring/
│   ├── helm-values/
│   │      └── kube-prometheus-stack-values.yaml
│   │
│   ├── dashboards/
│   ├── alerts/
│   ├── servicemonitors/
│   └── README.md
│
├── helm/
├── docs/
└── ...
```

---

# Best Practices

* Use a dedicated `monitoring` namespace.
* Keep all Helm values under version control.
* Never modify resources manually; update the values file and perform a Helm upgrade.
* Plan to let Argo CD manage the monitoring stack in a later enhancement.
* Size persistent storage according to environment requirements.
* Store Grafana credentials securely (for example, using Kubernetes Secrets or an external secret manager) rather than hardcoding them in production.

---

# Phase 10.2 Validation Checklist

Run these commands:

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get pvc -n monitoring
kubectl get daemonsets -n monitoring
kubectl get statefulsets -n monitoring
helm list -n monitoring
```

Confirm:

* ✅ Helm release is `deployed`.
* ✅ All pods are `Running`.
* ✅ PVCs are `Bound`.
* ✅ Node Exporter has one pod per node.
* ✅ Prometheus and Alertmanager StatefulSets are healthy.
* ✅ Grafana is running.

---

# Phase 10.2 Summary

You've deployed the core monitoring platform for RetailSphere:

* ✔️ Installed `kube-prometheus-stack` with Helm.
* ✔️ Created a dedicated `monitoring` namespace.
* ✔️ Enabled persistence for Prometheus, Grafana, and Alertmanager.
* ✔️ Deployed Prometheus Operator, Node Exporter, and kube-state-metrics.
* ✔️ Prepared a GitOps-friendly configuration structure.

## Before Moving to Phase 10.3

Once you complete the installation, please share the output of:

```bash
helm list -n monitoring
kubectl get pods -n monitoring
kubectl get pvc -n monitoring
kubectl get storageclass
```

If there are any issues (such as `Pending` PVCs or `CrashLoopBackOff` pods), we'll resolve them before continuing to **Phase 10.3 – Configure Prometheus**. This validation step is important because Prometheus depends on a healthy underlying installation.
