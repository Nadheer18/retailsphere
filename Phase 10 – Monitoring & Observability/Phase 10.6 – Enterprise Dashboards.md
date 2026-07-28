# RetailSphere Enterprise DevOps Project

# 🚀 Phase 10.6 – Enterprise Dashboards

Congratulations! This is one of the most visually impressive parts of the project. Up to now we've been collecting metrics—now we'll transform those metrics into operational dashboards.

---

# Objectives

By the end of this phase, you'll have dashboards for:

* ✅ Kubernetes Cluster
* ✅ Kubernetes Nodes
* ✅ Kubernetes Pods
* ✅ Spring Boot JVM
* ✅ Spring Boot Application
* ✅ MySQL
* ✅ RetailSphere Overview

---

# Dashboard Architecture

```text
                    Grafana

                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼

 Kubernetes        Spring Boot         MySQL

        │               │                │

        └───────────────┼────────────────┘
                        │
                   Prometheus
                        │
         ┌──────────────┴──────────────┐
         │                             │
 Node Exporter               Actuator Metrics
```

---

# Dashboard Organization

Create these folders in Grafana:

```text
Dashboards

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

---

# Kubernetes Dashboards

These dashboards are widely used in production.

| Dashboard                                  | Recommended Grafana.com ID |
| ------------------------------------------ | -------------------------: |
| Kubernetes Cluster Monitoring              |                    **315** |
| Node Exporter Full                         |                   **1860** |
| Kubernetes / Compute Resources / Cluster   |                  **15757** |
| Kubernetes / Compute Resources / Namespace |                  **15758** |
| Kubernetes / Compute Resources / Pod       |                  **15760** |
| Kubernetes Networking                      |                  **15759** |

---

# Spring Boot Dashboards

| Dashboard                    |                                                              Grafana.com ID |
| ---------------------------- | --------------------------------------------------------------------------: |
| JVM (Micrometer)             |                                                                    **4701** |
| Spring Boot Statistics       |                                                                   **12900** |
| Spring Boot 3.x / Micrometer | **17175** (or another current Micrometer-compatible dashboard if preferred) |

If a dashboard doesn't perfectly match your Micrometer metric names, we'll customize it later.

---

# MySQL Dashboards

Once MySQL metrics are exported (we'll enhance this in a later phase if needed), commonly used dashboards include:

| Dashboard      | Grafana.com ID |
| -------------- | -------------: |
| MySQL Overview |       **7362** |
| MySQL InnoDB   |      **14057** |

---

# Importing Dashboards

In Grafana:

```text
Dashboards
        ↓
New
        ↓
Import
```

Enter the dashboard ID (for example, `1860`), then:

* Select your **Prometheus** datasource.
* Click **Import**.

Repeat for each dashboard.

---

# Recommended Import Order

1. **1860** – Node Exporter Full
2. **315** – Kubernetes Cluster Monitoring
3. **15757** – Cluster Resources
4. **15758** – Namespace Resources
5. **15760** – Pod Resources
6. **4701** – JVM Metrics

This order lets you validate infrastructure first, then application metrics.

---

# Verify Data

After importing, check that:

### Node Dashboard

* CPU usage
* Memory usage
* Disk usage
* Network traffic

### Kubernetes Dashboard

* Running pods
* Deployments
* ReplicaSets
* Namespaces
* Resource requests and limits

### JVM Dashboard

* Heap memory
* Non-heap memory
* Garbage collection
* Thread count
* Class loading

If a panel shows **No data**, note which metric is missing—we can adjust the dashboard or query.

---

# Create a RetailSphere Folder

We'll eventually build custom dashboards such as:

```text
RetailSphere

├── API Requests
├── Order Processing
├── Authentication
├── Product Service
├── Database
├── JVM
└── Business Metrics
```

These will evolve as we add custom application metrics.

---

# Repository Structure

Keep exported dashboards under version control:

```text
retailsphere/

monitoring/

├── dashboards/
│
├── kubernetes/
│
├── springboot/
│
├── mysql/
│
├── retailsphere/
│
└── alerts/
```

Export dashboard JSON files into these directories so they can later be managed through GitOps.

---

# Enterprise Best Practices

* Use folders to separate infrastructure, platform, and application dashboards.
* Export dashboard JSON after any significant change.
* Keep dashboards in Git rather than only in Grafana.
* Prefer imported dashboards as a starting point, then customize them for RetailSphere.
* Review imported dashboards for compatibility with your metric names and Prometheus setup.

---

# Validation Checklist

By the end of this phase you should have:

* ✅ Grafana accessible.
* ✅ Prometheus datasource healthy.
* ✅ Kubernetes dashboards imported.
* ✅ Node dashboard showing metrics.
* ✅ JVM dashboard showing Spring Boot metrics.
* ✅ Dashboard folders created.
* ✅ Dashboard JSON ready to be stored in Git.

---

# One Small Enhancement

Your backend `Service` currently has an unnamed port:

```text
Port: <unset> 8080/TCP
```

Before **Phase 10.7 – Alertmanager**, we'll add a port name (for example, `http`) and create the `ServiceMonitor`. That ensures Prometheus scrapes your application automatically rather than relying only on manual verification.

---

# Next Phase

After importing and validating the dashboards, we'll continue with:

## 🚀 Phase 10.7 – Alertmanager

We'll configure:

* Node alerts
* Pod alerts
* Application alerts
* Resource utilization alerts
* Custom RetailSphere alerts
* Alert routing in Alertmanager
* Testing alerts before integrating notifications in Phase 10.8
