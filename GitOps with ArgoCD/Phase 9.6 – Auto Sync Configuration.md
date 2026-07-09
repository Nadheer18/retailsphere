# Phase 9.6 – Auto Sync Configuration

Currently your workflow is:

```text
Git Push
   ↓
ArgoCD detects change
   ↓
OutOfSync
   ↓
Manual Sync Required
   ↓
Kubernetes Updated
```

After this phase:

```text
Git Push
   ↓
ArgoCD detects change
   ↓
Automatic Sync
   ↓
Kubernetes Updated
```

No manual intervention required.

---

# Step 1 – Open RetailSphere Application

In ArgoCD UI:

```text
Applications
    ↓
retailsphere
```

---

# Step 2 – Enable Auto Sync

Click:

```text
APP DETAILS
```

or

```text
Actions → Edit
```

depending on your ArgoCD version.

Find:

```text
SYNC POLICY
```

Change from:

```text
Manual
```

to:

```text
Automatic
```

Enable:

```text
☑ Prune Resources
☑ Self Heal
```

---

# Step 3 – Save Changes

Click:

```text
Save
```

Application should now display:

```text
Auto-Sync: Enabled
```

---

# What These Options Mean

### Automatic Sync

```text
Git Changed
    ↓
ArgoCD Deploys Automatically
```

---

### Prune Resources

If a resource is removed from Git:

```text
Git
 └─ deployment removed

ArgoCD
 └─ deletes deployment from cluster
```

Cluster always matches Git.

---

### Self Heal

If someone manually changes the cluster:

```bash
kubectl scale deployment backend \
--replicas=5 \
-n retailsphere
```

ArgoCD will detect drift and restore:

```yaml
replicaCount: 2
```

from Git automatically.

This is one of GitOps' biggest advantages.

---

# Step 4 – Verify Auto Sync

Check application:

```text
Status: Synced
Health: Healthy
Sync Policy: Automated
```

---

# Step 5 – GitOps Auto Sync Test

Modify Helm values again.

```bash
cd ~/retailsphere
```

Edit:

```bash
vi helm/retailsphere/values.yaml
```

Change:

```yaml
replicaCount: 2
```

to:

```yaml
replicaCount: 3
```

---

# Step 6 – Push Change

```bash
git add .

git commit -m "Auto Sync validation"

git push origin feature/application-development
```

---

# Step 7 – Observe ArgoCD

Open ArgoCD UI.

Expected flow:

```text
Synced
   ↓
OutOfSync
   ↓
Syncing
   ↓
Healthy
   ↓
Synced
```

No Sync button click required.

---

# Step 8 – Verify Kubernetes

```bash
kubectl get deployment -n retailsphere
```

Expected:

```text
READY   UP-TO-DATE   AVAILABLE
3/3     3            3
```

Verify:

```bash
kubectl get pods -n retailsphere
```

Expected:

```text
backend-xxxxx
backend-yyyyy
backend-zzzzz
```

Three running pods.

---

# Step 9 – Self-Heal Test

Manually change deployment:

```bash
kubectl scale deployment backend \
--replicas=1 \
-n retailsphere
```

Verify:

```bash
kubectl get deployment -n retailsphere
```

Shows:

```text
1/1
```

Wait 1–3 minutes.

ArgoCD should automatically restore:

```text
3/3
```

because Git is the source of truth.

---

# Step 10 – Prune Test (Optional)

Create a temporary resource:

```bash
kubectl create deployment test-app \
--image=nginx \
-n retailsphere
```

Since it's not in Git, ArgoCD may flag it as unmanaged. Later, when managing resources through Git, Prune ensures deleted Git resources are removed from the cluster.

---

# Phase 9.6 Completion Criteria

✅ Auto Sync Enabled

✅ Prune Enabled

✅ Self Heal Enabled

✅ Git Push Triggers Deployment

✅ No Manual Sync Required

✅ Replica Count Updated Automatically

✅ Self-Heal Validated

---


## Next: Phase 9.7 – GitOps Disaster Recovery & Drift Management Validation

In Phase 9.7 we'll simulate real-world failures (deleted pods, scaled deployments, configuration drift) and verify that ArgoCD automatically restores the desired state from Git. This is one of the most valuable GitOps demonstrations for interviews and production environments.
