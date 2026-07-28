# RetailSphere Enterprise DevOps Project

# **Phase 10.3 – Configure Prometheus**

Congratulations! Your monitoring platform is running. In this phase, we'll understand **how Prometheus discovers and scrapes metrics** in Kubernetes.

> **Important:** Because you're using **kube-prometheus-stack**, most Prometheus configuration is managed by the **Prometheus Operator**. You won't manually edit `prometheus.yml` like in a traditional installation. Instead, you'll use Kubernetes custom resources such as `ServiceMonitor`, `PodMonitor`, and `PrometheusRule`.

---

# Phase Objectives

By the end of this phase, you will:

* ✅ Understand the Prometheus architecture
* ✅ Learn how the Prometheus Operator works
* ✅ Verify Prometheus is healthy
* ✅ Explore Kubernetes Service Discovery
* ✅ Validate scrape targets
* ✅ Learn basic PromQL
* ✅ Prepare for Spring Boot metrics in Phase 10.5

---

# 1. Prometheus Architecture

```text
                    Prometheus Operator
                           │
          ┌────────────────┴────────────────┐
          │                                 │
          ▼                                 ▼
     Prometheus CR                    Alertmanager CR
          │                                 │
          ▼                                 ▼
 Prometheus StatefulSet             Alertmanager StatefulSet
          │
          ▼
  Scrapes Metrics From
          │
 ┌────────┼──────────┬─────────────┐
 ▼        ▼          ▼             ▼
Nodes   kube-state  Services   Pods (via ServiceMonitor/PodMonitor)
```

---

# 2. Traditional Prometheus vs Prometheus Operator

| Traditional           | Operator-based (Your Setup)    |
| --------------------- | ------------------------------ |
| Edit `prometheus.yml` | Create `ServiceMonitor`        |
| Restart Prometheus    | Operator updates automatically |
| Static targets        | Kubernetes service discovery   |
| Manual reload         | Automatic reconciliation       |

This is why the Operator is preferred in Kubernetes.

---

# 3. Verify Prometheus Resources

Run:

```bash
kubectl get prometheus -n monitoring
```

Expected:

```text
NAME                                      VERSION   READY
monitoring-kube-prometheus-prometheus     v3.x.x    1
```

Check Alertmanager:

```bash
kubectl get alertmanager -n monitoring
```

Expected:

```text
NAME                                        READY
monitoring-kube-prometheus-alertmanager     1
```

---

# 4. Verify ServiceMonitors

The Helm chart has already created several `ServiceMonitor` objects.

```bash
kubectl get servicemonitor -n monitoring
```

Example output:

```text
monitoring-grafana
monitoring-kube-apiserver
monitoring-kube-controller-manager
monitoring-kube-proxy
monitoring-kube-scheduler
monitoring-kube-state-metrics
monitoring-prometheus-node-exporter
...
```

These objects tell Prometheus **which services to scrape**.

---

# 5. Verify PodMonitors

```bash
kubectl get podmonitor -n monitoring
```

Depending on the chart version, you may see none or a few resources. That's normal.

---

# 6. Verify Prometheus UI (Port Forward)

We'll access Prometheus locally from your workstation.

On the control plane:

```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

Then, on your local machine, open:

```text
http://localhost:9090
```

If you're SSH'd into the EC2 instance, you can instead use SSH port forwarding:

```bash
ssh -i <"path_pem"> -L 9090:localhost:9090 ubuntu@<CONTROL_PLANE_PUBLIC_IP>
```
Example:

```bash
ssh -i "C:\Users\nadhe\Downloads\mumbai-region.pem" -L 9090:localhost:9090 ubuntu@13.232.168.29
```
---

# 7. Verify Scrape Targets

In the Prometheus UI:

**Status → Targets**

You should see targets similar to:

* Kubernetes API Server
* kube-state-metrics
* Node Exporter
* Prometheus
* Alertmanager
* Grafana
* CoreDNS
* kubelet

Every target should ideally be **UP**.

If a target is **DOWN**, Prometheus will show the error message, making troubleshooting straightforward.

---

# 8. Verify Targets from the CLI

To inspect the Prometheus configuration:

```bash
kubectl get secret -n monitoring | grep prometheus
```

You can also inspect the Prometheus custom resource:

```bash
kubectl describe prometheus monitoring-kube-prometheus-prometheus -n monitoring
```

---

# 9. Understanding Kubernetes Service Discovery

Instead of specifying IP addresses, Prometheus watches the Kubernetes API.

```text
Kubernetes API
       │
       ▼
ServiceMonitor
       │
       ▼
Prometheus Operator
       │
       ▼
Prometheus Configuration
       │
       ▼
Automatic Scraping
```

When a matching service is created, Prometheus automatically starts scraping it.

---

# 10. PromQL Basics

PromQL is the query language used by Prometheus.

Try these queries in the Prometheus UI:

### Check if targets are up

```promql
up
```

---

### CPU usage (rate of CPU seconds)

```promql
rate(node_cpu_seconds_total[5m])
```

---

### Memory available

```promql
node_memory_MemAvailable_bytes
```

---

### Total memory

```promql
node_memory_MemTotal_bytes
```

---

### Filesystem usage

```promql
node_filesystem_avail_bytes
```

---

### Node load

```promql
node_load1
```

These metrics come from **Node Exporter**.

---

# 11. Verify Active Targets (CLI)

Port-forward the Prometheus service (if not already running):

```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

In another terminal:

```bash
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[].labels.job'
```

If `jq` isn't installed, you can simply inspect the JSON:

```bash
curl http://localhost:9090/api/v1/targets
```

---

# 12. Current Discovery Flow

```text
Node Exporter
      │
      ▼
Service
      │
      ▼
ServiceMonitor
      │
      ▼
Prometheus Operator
      │
      ▼
Prometheus
      │
      ▼
Grafana
```

The same pattern will be used for your RetailSphere backend in Phase 10.5.

---

# 13. Best Practices

* Avoid manually editing Prometheus configuration.
* Use `ServiceMonitor` for services and `PodMonitor` for direct pod scraping.
* Keep custom monitoring resources in Git for GitOps.
* Label your applications consistently to simplify discovery.
* Validate targets after every deployment.

---

# Validation Checklist

Please run the following commands and share the outputs:

```bash
kubectl get prometheus -n monitoring

kubectl get alertmanager -n monitoring

kubectl get servicemonitor -n monitoring

kubectl get podmonitor -n monitoring

kubectl describe prometheus monitoring-kube-prometheus-prometheus -n monitoring
```

If you can access the Prometheus UI, also verify that the main targets are **UP**.

---

# Phase 10.3 Summary

In this phase, you've learned:

* ✔️ How the Prometheus Operator manages Prometheus.
* ✔️ How Kubernetes Service Discovery replaces static scrape configurations.
* ✔️ The role of `ServiceMonitor` and `PodMonitor`.
* ✔️ How to inspect Prometheus resources.
* ✔️ Basic PromQL queries for cluster metrics.

## Next Phase

**Phase 10.4 – Configure Grafana**

We'll configure Grafana for enterprise use by:

* Connecting it to Prometheus (if not already configured)
* Enabling persistent dashboards
* Setting up authentication
* Organizing folders
* Importing Kubernetes dashboards
* Preparing for custom RetailSphere dashboards in Phase 10.6.
