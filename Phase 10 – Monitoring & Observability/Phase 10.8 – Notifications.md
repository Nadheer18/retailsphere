# RetailSphere Enterprise DevOps Project

# 🚀 Phase 10.8 – Notifications

This phase connects **Alertmanager** to notification channels so alerts reach you automatically.

---

## Before We Begin

There's one important item from **Phase 10.5/10.7** that we should complete first:

> **Your Spring Boot application is exposing `/actuator/prometheus` correctly, but we have not yet created the `ServiceMonitor`.**

That means:

* ✅ Kubernetes alerts work.
* ✅ Node alerts work.
* ✅ Infrastructure alerts work.
* ⚠️ **RetailSphere application alerts are not fully functional yet** because Prometheus is not automatically scraping the backend.

We'll complete the `ServiceMonitor` before **Phase 10.9** so application metrics and alerts are fully integrated.

---

# Notification Architecture

```text
Spring Boot
      │
      ▼
Prometheus
      │
      ▼
Alert Rules
      │
      ▼
Alertmanager
      │
 ┌────┴─────┐
 ▼          ▼
Telegram   Slack
```

---

# Notification Channels

For RetailSphere we'll configure:

* ✅ Telegram (recommended)
* ✅ Slack (optional)

Telegram is excellent for a portfolio project because it's free and easy to demonstrate.

---

# Step 1 – Verify Alertmanager

```bash
kubectl get pods -n monitoring
```

Expected:

```text
alertmanager-monitoring-kube-prometheus-alertmanager-0
```

---

# Step 2 – Open Alertmanager

```bash
kubectl port-forward -n monitoring \
svc/monitoring-kube-prometheus-alertmanager \
9093:9093
```

Open:

```
http://localhost:9093
```

---

# Step 3 – Telegram Bot

Create a bot using **@BotFather** in Telegram.

You'll receive:

```
Bot Token

123456789:AAxxxxxxxxxxxxxxxx
```

Save it securely.

---

# Step 4 – Get Chat ID

Send a message to your bot.

Then retrieve the chat ID using the Telegram Bot API.

You'll get something like:

```text
chat_id

987654321
```

---

# Step 5 – Create Kubernetes Secret

Do **not** hard-code credentials in YAML.

Create a Secret:

```bash
kubectl create secret generic alertmanager-telegram \
-n monitoring \
--from-literal=bot-token='<BOT_TOKEN>' \
--from-literal=chat-id='<CHAT_ID>'
```

Verify:

```bash
kubectl get secret -n monitoring
```

---

# Step 6 – Configure Alertmanager

Update the Alertmanager configuration to reference your Telegram credentials and define routing rules.

A typical enterprise setup includes:

* A default receiver.
* A Telegram receiver.
* Grouping alerts by alert name.
* Reasonable repeat intervals to avoid notification storms.

We'll use your existing `kube-prometheus-stack` values file so the configuration is managed through Helm and Git.

---

# Step 7 – Apply the Configuration

If you're managing the monitoring stack with Helm:

```bash
helm upgrade monitoring prometheus-community/kube-prometheus-stack \
-n monitoring \
-f monitoring/helm-values/kube-prometheus-stack-values.yaml
```

This keeps Alertmanager configuration under version control.

---

# Step 8 – Test Notifications

Generate a simple test alert by temporarily scaling your backend down:

```bash
kubectl scale deployment backend \
--replicas=0 \
-n retailsphere
```

If the backend is already being scraped through a `ServiceMonitor`, Alertmanager should eventually send a notification.

Restore it afterward:

```bash
kubectl scale deployment backend \
--replicas=1 \
-n retailsphere
```

---

# Repository Structure

Organize notification-related files like this:

```text
monitoring/
├── alerts/
│   ├── retailsphere-alerts.yaml
│   ├── kubernetes-alerts.yaml
│   └── node-alerts.yaml
│
├── alertmanager/
│   └── alertmanager-config.yaml
│
└── helm-values/
    └── kube-prometheus-stack-values.yaml
```

---

# Enterprise Best Practices

* Store Alertmanager configuration in Git.
* Store tokens only in Kubernetes Secrets.
* Separate infrastructure alerts from application alerts.
* Use different severities (warning, critical).
* Avoid exposing secrets in repositories or logs.
* Test notification delivery after every configuration change.

---

# Phase 10 Status

| Phase                             | Status                                                                       |
| --------------------------------- | ---------------------------------------------------------------------------- |
| 10.1 – Observability Architecture | ✅                                                                            |
| 10.2 – Monitoring Stack           | ✅                                                                            |
| 10.3 – Prometheus                 | ✅                                                                            |
| 10.4 – Grafana                    | ✅                                                                            |
| 10.5 – Spring Boot Metrics        | ✅ *(application instrumentation complete; ServiceMonitor still to be added)* |
| 10.6 – Enterprise Dashboards      | ✅                                                                            |
| 10.7 – Alertmanager               | ✅ *(infrastructure rules; custom application alerts pending ServiceMonitor)* |
| 10.8 – Notifications              | 🟡 Ready to configure                                                        |

---

# Before Phase 10.9

I recommend we **complete the missing `ServiceMonitor` first**.

It's a small but important gap. Once it's in place:

* Prometheus will automatically scrape your RetailSphere backend.
* Your custom application dashboards will populate reliably.
* Application-specific alerts (such as `RetailSphereBackendDown`) will function correctly.

After that, we'll move to **Phase 10.9 – Validation & Troubleshooting**, where we'll perform end-to-end testing of the entire monitoring and alerting stack. This will ensure every component—from Spring Boot metrics to Grafana dashboards and Alertmanager notifications—is working as expected.
