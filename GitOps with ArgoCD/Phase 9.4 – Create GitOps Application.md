# Phase 9.4 – Create GitOps Application

Now we'll create the RetailSphere Application in ArgoCD.

This tells ArgoCD:

```text
Git Repository
      ↓
Helm Chart
      ↓
retailsphere Namespace
      ↓
Kubernetes Cluster
```

---

# Step 1 – Open Applications

In ArgoCD UI:

```text
Applications
    ↓
+ NEW APP
```

---

# Step 2 – Application Details

Fill the form:

### General

```text
Application Name:
retailsphere

Project:
default

Sync Policy:
Manual
```

Keep Manual for now. We'll enable Auto Sync in Phase 9.6.

---

# Step 3 – Source Configuration

### Repository URL

```text
https://github.com/Nadheer18/retailsphere.git
```

### Revision

If you are deploying from your feature branch:

```text
feature/application-development
```

If Phase 8 was merged to develop:

```text
develop
```

Use whichever branch currently contains your Helm chart.

### Path

```text
helm/retailsphere
```

ArgoCD should automatically detect:

```text
HELM
```

---

# Step 4 – Destination

### Cluster URL

```text
https://kubernetes.default.svc
```

### Namespace

```text
retailsphere
```

---

# Step 5 – Create Application

Click:

```text
Create
```

You should now see:

```text
retailsphere
```

in the Applications page.

Status will likely show:

```text
OutOfSync
```

This is normal because ArgoCD has not deployed anything yet.

---

# Step 6 – Review Resources

Open the application.

You should see resources similar to:

```text
Deployment
  ├── backend

Service
  ├── backend

ConfigMaps (if any)

Secrets (if any)
```

The exact list depends on your Helm chart templates.

---

# Step 7 – First Sync

Click:

```text
SYNC
```

Then:

```text
Synchronize
```

ArgoCD will:

```text
Read Helm Chart
      ↓
Render Templates
      ↓
Apply Resources
      ↓
Deploy To Kubernetes
```

---

# Step 8 – Verify Sync

Application should become:

```text
Synced
Healthy
```

Green status.

---

# Step 9 – Verify from Kubernetes

On the Infra Server:

```bash
kubectl get all -n retailsphere
```

Expected:

```text
pod/retailsphere-backend-xxxxx

svc/backend

deployment.apps/backend
```

(or whatever names are defined in your Helm chart).

---

# Troubleshooting

If application shows:

```text
Missing
```

Check:

```text
Path = helm/retailsphere
```

If it shows:

```text
Manifest generation error
```

Check:

```bash
helm lint helm/retailsphere
```

If it shows:

```text
Permission denied
```

Verify repository connection under:

```text
Settings → Repositories
```

---

# Phase 9.4 Completion Criteria

✅ ArgoCD Application Created

✅ Repository Connected

✅ Helm Chart Detected

✅ First Sync Executed

✅ Application Status = Synced

✅ Application Status = Healthy

---

After the first sync, check:

```bash
kubectl get all -n retailsphere
```

and the ArgoCD application status is Healthy,Then we'll continue to Phase 9.5 – Deploy RetailSphere via GitOps Validation.
and the ArgoCD application status screenshot/output (Healthy/Synced or any errors). Then we'll continue to **Phase 9.5 – Deploy RetailSphere via GitOps Validation**.
