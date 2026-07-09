# Phase 9.5 – Deploy RetailSphere via GitOps Validation

At this stage, ArgoCD should be managing your RetailSphere deployment.

The goal of this phase is to prove that:

```text
Git Repository
      ↓
ArgoCD
      ↓
Kubernetes
```

is working correctly.

---

# Step 1 – Verify ArgoCD Application Status

In ArgoCD UI, RetailSphere application should show:

```text
Status: Synced
Health: Healthy
```

If not:

```text
SYNC → Synchronize
```

and wait until it becomes Healthy.

---

# Step 2 – Verify Kubernetes Resources

On the master node:

```bash
kubectl get all -n retailsphere
```

Expected:

```text
pods
services
deployments
replicasets
```

Example:

```text
NAME                              READY
pod/backend-xxxxx                 1/1

NAME               TYPE
service/backend    ClusterIP

NAME                       READY
deployment/backend         1/1
```

---

# Step 3 – Verify Deployment Ownership

Check ArgoCD labels:

```bash
kubectl get deployment -n retailsphere --show-labels
```

You should see labels similar to:

```text
app.kubernetes.io/instance=retailsphere
```

This confirms ArgoCD created/manages the resources.

---

# Step 4 – Verify Application Availability

Check pods:

```bash
kubectl get pods -n retailsphere
```

All should be:

```text
Running
```

Check services:

```bash
kubectl get svc -n retailsphere
```

---

# Step 5 – Port Forward Test

If backend service exists:

```bash
kubectl port-forward svc/backend 8080:8080 -n retailsphere
```

Open:

```text
http://localhost:8080/swagger-ui/index.html
```

Or:

```text
http://<node-ip>:<nodeport>
```

depending on your service configuration.

---

# Step 6 – GitOps Change Validation

Now we test the entire GitOps workflow.

### Edit Helm Values

```bash
cd ~/retailsphere
```

Open:

```bash
vi helm/retailsphere/values.yaml
```

Change:

```yaml
replicaCount: 1
```

to:

```yaml
replicaCount: 2
```

---

# Step 7 – Commit & Push

```bash
git add .

git commit -m "GitOps validation replica update"

git push origin feature/application-development
```

---

# Step 8 – Observe ArgoCD

Go to ArgoCD UI.

Application should become:

```text
OutOfSync
```

because Git changed.

This proves ArgoCD detected the repository update.

---

# Step 9 – Manual Sync

Click:

```text
SYNC
```

Then:

```text
Synchronize
```

Wait until:

```text
Healthy
Synced
```

---

# Step 10 – Verify Replica Update

Check deployment:

```bash
kubectl get deployment -n retailsphere
```

Expected:

```text
READY   UP-TO-DATE   AVAILABLE
2/2     2            2
```

or equivalent output showing 2 replicas.

Verify:

```bash
kubectl get pods -n retailsphere
```

Expected:

```text
backend-xxxxx
backend-yyyyy
```

Two pods running.

---

# GitOps Validation Success

You have now demonstrated:

```text
Git Commit
    ↓
GitHub
    ↓
ArgoCD Detects Change
    ↓
Sync
    ↓
Kubernetes Updated
```

This is the core GitOps workflow used in many organizations.

---

# Phase 9.5 Completion Criteria

✅ RetailSphere Application Healthy

✅ RetailSphere Application Synced

✅ Resources Managed by ArgoCD

✅ Git Change Detected

✅ ArgoCD Shows OutOfSync

✅ Sync Executed

✅ Deployment Updated

✅ Replica Count Changed Successfully

---

## Next Phase: 9.6 – Auto Sync Configuration

Currently:

```text
GitHub
   ↓
ArgoCD
   ↓
Manual Sync
```

Next we will enable:

```text
GitHub
   ↓
ArgoCD
   ↓
Automatic Sync
   ↓
Kubernetes
```

so every Git push is deployed automatically without pressing the Sync button.
