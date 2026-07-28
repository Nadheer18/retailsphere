# RetailSphere Enterprise DevOps Project

# 🚀 Phase 10.7 – Alertmanager

You've reached one of the most valuable enterprise DevOps features.

Until now:

* **Prometheus** → Collects metrics
* **Grafana** → Visualizes metrics

Now we'll add:

* **Alertmanager** → Sends notifications when something is wrong.

---

# Alerting Architecture

```text
                    RetailSphere

                         │
                         ▼
                  Spring Boot App

                         │
                         ▼
                    Prometheus
               (Evaluate Rules)

                         │
                Alert Rules Fire

                         ▼
                  Alertmanager

          ┌──────────┴──────────┐
          ▼                     ▼
      Telegram              Slack
      (Phase 10.8)         (Optional)

                         │
                         ▼
                     DevOps Team
```

---

# Objectives

By the end of this phase you will have alerts for:

* ✅ Node Down
* ✅ High CPU Usage
* ✅ High Memory Usage
* ✅ Disk Usage
* ✅ Pod CrashLoopBackOff
* ✅ Pod Not Ready
* ✅ Deployment Replica Mismatch
* ✅ RetailSphere Backend Down
* ✅ Spring Boot Health Down
* ✅ Prometheus Down

---

# Step 1 – Verify Alertmanager

Run:

```bash
kubectl get pods -n monitoring
```

Expected:

```text
alertmanager-monitoring-kube-prometheus-alertmanager-0
```

Running.

---

Verify the service:

```bash
kubectl get svc -n monitoring
```

Expected:

```text
monitoring-kube-prometheus-alertmanager
```

---

# Step 2 – Open Alertmanager UI

Port-forward:

```bash
kubectl port-forward -n monitoring \
svc/monitoring-kube-prometheus-alertmanager \
9093:9093
```

Open:

```text
http://localhost:9093
```

Initially, you'll likely see no active alerts.

---

# Step 3 – Existing Alert Rules

The `kube-prometheus-stack` chart already installs many production-ready alert rules.

Check them:

```bash
kubectl get prometheusrule -n monitoring
```

You should see several `PrometheusRule` resources.

---

# Step 4 – View Existing Rules

Inspect one:

```bash
kubectl describe prometheusrule -n monitoring
```

You'll find rules such as:

* KubeNodeNotReady
* KubePodCrashLooping
* KubeDeploymentReplicasMismatch
* KubeCPUOvercommit
* KubeMemoryOvercommit

These are maintained by the chart and are a good enterprise baseline.

---

# Step 5 – RetailSphere Custom Rules

Create a new file:

```text
monitoring/
└── alerts/
    └── retailsphere-alerts.yaml
```

We'll add custom rules for your application.

## Example – Backend Down

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule

metadata:
  name: retailsphere-alerts
  namespace: monitoring

spec:
  groups:
    - name: retailsphere.rules

      rules:

      - alert: RetailSphereBackendDown

        expr: up{job="retailsphere-backend"} == 0

        for: 1m

        labels:
          severity: critical

        annotations:
          summary: "RetailSphere backend is down"

          description: "Prometheus cannot scrape the RetailSphere backend."
```

> **Note:** We'll adjust the `job` label after the `ServiceMonitor` is created in the next step.

---

# Step 6 – High JVM Memory

Once the backend is being scraped automatically:

```yaml
- alert: HighJVMMemory

  expr: jvm_memory_used_bytes / jvm_memory_max_bytes > 0.90

  for: 5m

  labels:
    severity: warning

  annotations:
    summary: "High JVM Memory"

    description: "JVM heap usage is above 90%."
```

---

# Step 7 – High CPU

```yaml
- alert: HighCPUUsage

  expr: rate(process_cpu_usage[5m]) > 0.80

  for: 5m

  labels:
    severity: warning
```

You may refine this expression later based on your application's exported metrics.

---

# Step 8 – Backend Health

Since you already enabled:

```text
/actuator/health
```

You can later create an alert based on the `up` metric from Prometheus or additional health metrics exposed by Actuator.

---

# Step 9 – Apply Rules

After creating the rule file:

```bash
kubectl apply -f monitoring/alerts/
```

Verify:

```bash
kubectl get prometheusrule -n monitoring
```

---

# Step 10 – Verify in Prometheus

Open:

```text
Prometheus

↓

Alerts
```

You'll see:

* Pending
* Firing
* Inactive

for all configured rules.

---

# Step 11 – Simulate Alerts

Examples:

Stop the backend:

```bash
kubectl scale deploy backend \
--replicas=0 \
-n retailsphere
```

Wait one minute.

You should see:

```text
RetailSphereBackendDown
```

After testing:

```bash
kubectl scale deploy backend \
--replicas=1 \
-n retailsphere
```

---

# Repository Structure

```text
monitoring/

alerts/

├── retailsphere-alerts.yaml

├── node-alerts.yaml

├── kubernetes-alerts.yaml

└── springboot-alerts.yaml
```

This organization makes it easy to manage alert rules as your platform grows.

---

# Enterprise Best Practices

* Keep vendor-provided rules from `kube-prometheus-stack` intact.
* Store custom alert rules in Git.
* Separate infrastructure alerts from application alerts.
* Start with warning and critical severities.
* Test each alert before wiring it to notifications.

---

# One Important Item Before Finalizing

During Phase 10.5 we identified that your backend is exposing Prometheus metrics, but we **have not yet created the `ServiceMonitor`**. Until that's done:

* Infrastructure alerts will work.
* Application-specific alerts (such as `RetailSphereBackendDown`) won't fire correctly because Prometheus isn't automatically scraping your backend.

So before we complete Phase 10.7, we'll add the `ServiceMonitor` and verify that the backend appears as a Prometheus target. Then your custom application alerts will work as intended.

---

# Next Phase

## 🚀 Phase 10.8 – Notifications

We'll connect Alertmanager to:

* 📱 Telegram
* 💬 Slack (optional)

and then generate real alerts to confirm end-to-end notification delivery. This completes the monitoring pipeline from metric collection to actionable alerts.
