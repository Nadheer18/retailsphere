# **Phase 10.1 – Observability Architecture & Design**

Welcome to Phase 10. This phase introduces one of the most important capabilities of a production-grade Kubernetes platform: **Observability**.

Until now, we've built a complete deployment platform:

* ✅ Infrastructure (Terraform)
* ✅ Configuration Management (Ansible)
* ✅ Application (Spring Boot)
* ✅ Containerization (Docker)
* ✅ Kubernetes
* ✅ CI/CD (Jenkins)
* ✅ GitOps (Argo CD)

Now we'll make the platform **observable**—able to tell us **what is happening**, **why it's happening**, and **where problems are occurring**.

---

# What is Observability?

Observability is the ability to understand the internal state of a system by examining the data it produces.

Think of your RetailSphere application like a car:

* Dashboard speedometer → Monitoring
* Engine warning light → Alerts
* Dash camera → Logging
* GPS route → Tracing

When everything works, observability helps confirm system health. When something fails, it helps identify the root cause quickly.

---

# The Three Pillars of Observability

## 1. Monitoring (Metrics)

Metrics are numeric values collected over time.

Examples:

* CPU Usage
* Memory Usage
* Disk Usage
* Network Traffic
* JVM Heap
* HTTP Requests
* Request Duration
* Database Connections

Prometheus stores these metrics.

Example:

```
CPU Usage = 48%

Memory Usage = 67%

Requests/sec = 320

Response Time = 210ms
```

Metrics answer questions like:

* Is CPU increasing?
* Are pods restarting?
* Is memory usage growing?
* Is the application slow?

---

## 2. Logging

Logs are text records of events.

Example:

```
2026-07-04 10:22:15 INFO User login successful

2026-07-04 10:22:18 ERROR Database timeout

2026-07-04 10:22:19 WARN Retry initiated
```

Logs answer:

* What exactly happened?
* Which exception occurred?
* Which user triggered it?

We will implement centralized logging in **Phase 11**.

---

## 3. Distributed Tracing

Tracing follows a request across services.

Example:

```
User

↓

API Gateway

↓

Spring Boot

↓

MySQL

↓

Payment Service

↓

Notification Service
```

Tracing answers:

* Where is the request slow?
* Which service failed?
* Which API caused the delay?

Tracing becomes especially valuable when RetailSphere evolves into a microservices architecture.

---

# Monitoring vs Logging vs Tracing

| Feature             | Monitoring       | Logging              | Tracing                |
| ------------------- | ---------------- | -------------------- | ---------------------- |
| Data Type           | Metrics          | Text                 | Request Flow           |
| Storage             | Prometheus       | Loki / Elasticsearch | Tempo / Jaeger         |
| Best For            | Resource Health  | Errors & Events      | End-to-End Performance |
| Alerting            | Yes              | Limited              | Limited                |
| Historical Analysis | Excellent        | Excellent            | Excellent              |
| Typical Questions   | "Is it healthy?" | "What happened?"     | "Where is it slow?"    |

---

# RetailSphere Observability Architecture

```
                      Users
                        │
                        ▼
                 NGINX Ingress
                        │
                        ▼
              RetailSphere Backend
                        │
                        ▼
                     MySQL

──────────────────────────────────────────────

Metrics Collection

Node Exporter
      │
      ▼
Prometheus

kube-state-metrics
      │
      ▼
Prometheus

Spring Boot Actuator
      │
      ▼
Prometheus

Alert Rules
      │
      ▼
Alertmanager
      │
      ▼
Telegram

──────────────────────────────────────────────

Visualization

Prometheus
      │
      ▼
Grafana Dashboards
```

---

# Components We'll Deploy

## 1. Prometheus

Purpose:

* Collect metrics
* Store metrics
* Execute PromQL queries
* Evaluate alert rules

It is the central metrics engine.

---

## 2. Grafana

Purpose:

* Visualize metrics
* Build dashboards
* Display cluster health
* Show JVM metrics
* Show application metrics
* Show MySQL metrics

Grafana reads data from Prometheus.

---

## 3. Alertmanager

Purpose:

* Receive alerts from Prometheus
* Group alerts
* Deduplicate notifications
* Send notifications to Telegram (and optionally Slack later)

---

## 4. Node Exporter

Runs on every Kubernetes node.

Collects:

* CPU
* Memory
* Disk
* Filesystem
* Network
* Load Average
* Temperature (where available)

---

## 5. kube-state-metrics

Collects Kubernetes object states, such as:

* Pods
* Deployments
* ReplicaSets
* StatefulSets
* DaemonSets
* Jobs
* CronJobs
* PVCs
* Nodes
* Namespaces

This provides Kubernetes resource status, not operating system metrics.

---

## 6. Spring Boot Actuator

Exposes application metrics:

* JVM Memory
* JVM Threads
* HTTP Requests
* Response Time
* Garbage Collection
* Database Connection Pool
* Cache Metrics
* Custom Business Metrics (if added later)

Prometheus scrapes these metrics through the `/actuator/prometheus` endpoint.

---

# Complete Enterprise Data Flow

```
Linux Nodes
        │
        ▼
Node Exporter

Kubernetes Cluster
        │
        ▼
kube-state-metrics

RetailSphere Backend
        │
        ▼
Spring Boot Actuator

MySQL
        │
        ▼
MySQL Exporter (Phase 10.6)

──────────────────────────────

All Metrics

        │

        ▼

Prometheus

        │

 ┌──────┴─────────┐

 ▼                ▼

Grafana      Alertmanager

                  │

                  ▼

             Telegram
```

---

# Kubernetes Namespace Design

We'll isolate observability components from application workloads.

```
retailsphere
│
├── backend
├── mysql

monitoring
│
├── prometheus
├── grafana
├── alertmanager
├── node-exporter
├── kube-state-metrics
```

This separation simplifies access control, upgrades, and troubleshooting.

---

# Folder Structure

We'll maintain monitoring assets separately from Helm charts used for the application.

```text
retailsphere/
│
├── docs/
│   └── phase10/
│       ├── 01-observability-architecture.md
│       ├── 02-prometheus.md
│       ├── 03-grafana.md
│       ├── 04-alertmanager.md
│       ├── 05-dashboards.md
│       ├── 06-alert-rules.md
│       └── 07-troubleshooting.md
│
├── monitoring/
│   ├── helm-values/
│   │   ├── kube-prometheus-stack-values.yaml
│   │   └── grafana-values.yaml
│   │
│   ├── dashboards/
│   │   ├── kubernetes/
│   │   ├── nodes/
│   │   ├── springboot/
│   │   └── mysql/
│   │
│   ├── alerts/
│   │   ├── node-alerts.yaml
│   │   ├── pod-alerts.yaml
│   │   ├── app-alerts.yaml
│   │   └── mysql-alerts.yaml
│   │
│   ├── servicemonitors/
│   │   └── springboot-servicemonitor.yaml
│   │
│   └── README.md
│
└── helm/
```

This layout keeps observability configuration modular, version-controlled, and ready for GitOps.

---

# Enterprise Best Practices

For RetailSphere, we will:

* Deploy the monitoring stack using Helm.
* Manage configuration through Git and Argo CD.
* Use persistent storage for Prometheus and Grafana.
* Avoid editing Kubernetes resources manually.
* Create reusable dashboards and alert rules.
* Organize documentation by phase.
* Prepare the design for future integration with centralized logging, tracing, and an eventual Amazon EKS migration.

---

# How This Fits with Future Phases

| Phase          | Goal                         | Integration                                                                   |
| -------------- | ---------------------------- | ----------------------------------------------------------------------------- |
| **Phase 10**   | Metrics & Alerts             | Prometheus, Grafana, Alertmanager                                             |
| **Phase 11**   | Centralized Logging          | Loki + Promtail + Grafana                                                     |
| **Phase 12**   | DevSecOps                    | Security monitoring and compliance metrics                                    |
| **Phase 13**   | Amazon EKS Migration         | Reuse the same monitoring architecture with minimal changes                   |
| **Phase 13.5** | Dev → Staging → Production   | Environment-specific dashboards and alert policies                            |
| **Phase 14+**  | Advanced Enterprise Features | Distributed tracing (e.g., Tempo or Jaeger), SLOs, and advanced observability |

---

# Phase 10.1 Summary

In this phase, we established the observability architecture for RetailSphere:

* ✔️ Learned the three pillars of observability: Metrics, Logs, and Traces.
* ✔️ Understood the roles of Prometheus, Grafana, Alertmanager, Node Exporter, kube-state-metrics, and Spring Boot Actuator.
* ✔️ Designed an enterprise observability architecture and data flow.
* ✔️ Defined a dedicated `monitoring` namespace.
* ✔️ Planned a GitOps-friendly folder structure.
* ✔️ Ensured compatibility with upcoming phases for logging, security, EKS migration, and multi-environment deployments.

## Next Phase

**Phase 10.2 – Install Monitoring Stack**

We'll deploy the complete monitoring stack using the **`kube-prometheus-stack` Helm chart**, configure persistent storage, and verify that Prometheus, Grafana, Alertmanager, Node Exporter, and kube-state-metrics are running correctly in your Kubernetes cluster.
