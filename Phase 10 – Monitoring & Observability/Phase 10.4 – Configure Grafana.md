# RetailSphere Enterprise DevOps Project

# **Phase 10.4 – Configure Grafana**

Congratulations! 🎉

Your monitoring platform is fully operational. Now we'll configure **Grafana**, which is the visualization layer of your observability stack.

---

# Phase Objectives

By the end of this phase, you will have:

* ✅ Grafana accessible
* ✅ Admin login configured
* ✅ Prometheus datasource verified
* ✅ Persistent storage verified
* ✅ Enterprise folder structure
* ✅ Dashboard provisioning strategy
* ✅ Ready for importing dashboards in Phase 10.6

---

# Grafana Architecture

```text
                   Grafana
                      │
        ┌─────────────┴─────────────┐
        │                           │
        ▼                           ▼
   Prometheus                 Alertmanager
        │
        ▼
  Kubernetes Metrics
        │
        ├── Node Exporter
        ├── kube-state-metrics
        ├── kubelet
        ├── API Server
        └── Spring Boot (Phase 10.5)
```

Grafana **does not collect metrics**. It reads metrics from Prometheus and presents them as dashboards.

---

# Step 1 – Verify Grafana Pod

```bash
kubectl get pods -n monitoring | grep grafana
```

Expected:

```text
monitoring-grafana-xxxxxxxxxx-xxxxx   3/3 Running
```

---

# Step 2 – Verify Grafana Service

```bash
kubectl get svc monitoring-grafana -n monitoring
```

Expected:

```text
NAME                  TYPE        PORT
monitoring-grafana    ClusterIP   80/TCP
```

---

# Step 3 – Access Grafana

Since you're already using SSH tunneling for Prometheus, open another local port for Grafana.

On the EC2 instance:

```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```

You should see:

```text
Forwarding from 127.0.0.1:3000 -> 3000
```

Now open your browser:

```text
http://localhost:3000
```

---

# Step 4 – Login

Username:

```text
admin
```

Password:

```text
admin123
```

> This works because you set:

```yaml
grafana:
  adminPassword: admin123
```

Later we'll move credentials to Kubernetes Secrets.

---

# Step 5 – Verify Persistence

Check the PVC:

```bash
kubectl get pvc -n monitoring monitoring-grafana
```

Expected:

```text
STATUS: Bound
```

You already verified this in Phase 10.2.

This means dashboards and Grafana configuration survive pod restarts.

---

# Step 6 – Verify Prometheus Datasource

After logging in:

Navigate to:

```text
Connections
    ↓
Data Sources
```

(or **Administration → Data Sources**, depending on the Grafana version)

You should already see a datasource similar to:

```text
Prometheus
```

Open it.

Verify:

```text
URL

http://monitoring-kube-prometheus-prometheus.monitoring.svc:9090
```

Click:

```text
Save & Test
```

Expected:

```text
Datasource is working
```

> **Note:** The exact URL may vary slightly depending on the Helm chart version. The important part is that the test succeeds.

---

# Step 7 – Verify Datasource from Kubernetes

Run:

```bash
kubectl get configmap -n monitoring | grep grafana
```

You'll typically see ConfigMaps related to Grafana dashboards and datasources created by the Helm chart.

---

# Step 8 – Create Enterprise Dashboard Structure

We'll organize dashboards by category.

Create folders in Grafana:

```
Dashboards
│
├── Kubernetes
│
├── Infrastructure
│
├── RetailSphere
│
├── Spring Boot
│
├── Database
│
└── Alerts
```

This keeps dashboards organized as the platform grows.

---

# Step 9 – Repository Structure

Extend your repository:

```text
retailsphere/
│
├── monitoring/
│
│   ├── dashboards/
│   │
│   ├── kubernetes/
│   │
│   ├── infrastructure/
│   │
│   ├── springboot/
│   │
│   ├── mysql/
│   │
│   ├── retailsphere/
│   │
│   └── alerts/
```

Later, we'll export dashboard JSON files and store them here under Git for GitOps.

---

# Step 10 – Recommended Dashboards

In the next phase we'll import dashboards such as:

| Dashboard              | Purpose            |
| ---------------------- | ------------------ |
| Kubernetes Cluster     | Cluster overview   |
| Node Exporter Full     | CPU, Memory, Disk  |
| Kubernetes Pods        | Pod health         |
| Kubernetes Deployments | Deployment status  |
| Spring Boot            | JVM & HTTP metrics |
| MySQL                  | Database metrics   |
| Alertmanager           | Alert status       |

---

# Step 11 – Verify Grafana Provisioning

Run:

```bash
kubectl describe configmap -n monitoring | grep grafana
```

This helps you see the ConfigMaps created for Grafana provisioning.

---

# Enterprise Best Practices

* Use folders to organize dashboards.
* Keep dashboards under version control by exporting JSON files.
* Avoid creating dashboards directly in production without committing them to Git.
* Keep the Prometheus datasource managed by Helm or provisioning files rather than manual edits.
* Use persistent storage (already enabled).

---

# Validation Checklist

Please complete these checks:

### From the browser

* ✅ Open `http://localhost:3000`
* ✅ Log in with `admin / admin123`
* ✅ Verify the Prometheus datasource exists.
* ✅ Click **Save & Test** and confirm it reports success.

### From the cluster

Run:

```bash
kubectl get configmap -n monitoring | grep grafana

kubectl get secret -n monitoring | grep grafana
```

Share the outputs if you'd like me to verify them.

---

# Phase 10.4 Summary

You've configured the Grafana visualization layer:

* ✔️ Verified Grafana deployment.
* ✔️ Logged into the Grafana UI.
* ✔️ Confirmed persistence.
* ✔️ Verified the Prometheus datasource.
* ✔️ Defined an enterprise dashboard organization.
* ✔️ Prepared the repository for dashboard versioning.

---

# Next Phase

## **Phase 10.5 – Spring Boot Metrics**

This is where your **RetailSphere application** becomes observable.

We'll:

* Add **Spring Boot Actuator**.
* Enable **Micrometer Prometheus**.
* Expose the `/actuator/prometheus` endpoint.
* Create a `ServiceMonitor`.
* Verify Prometheus scrapes your RetailSphere backend.
* Prepare application-specific dashboards for Phase 10.6.

This is a key milestone because you'll move from monitoring the Kubernetes platform to monitoring your own application.
