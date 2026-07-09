# Phase 9.3 – Register RetailSphere Git Repository in ArgoCD

Now that ArgoCD is accessible, we will connect your GitHub repository so ArgoCD can pull the Helm chart and deploy RetailSphere automatically.

---

# Step 1 – Verify Repository Structure

Your repository should look like:

```text
retailsphere/
├── terraform/
├── ansible/
├── app/
└── helm/
    └── retailsphere/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
```

Verify:

```bash
cd ~/retailsphere

git branch

git status

tree helm/retailsphere
```

---

# Step 2 – Ensure Latest Code Is Pushed

```bash
git add .

git commit -m "Phase 8 Helm completed"

git push origin feature/application-development
```

If your Helm chart is already pushed, continue.

---

# Step 3 – Register Repository in ArgoCD

In ArgoCD UI:

```text
Settings
    ↓
Repositories
    ↓
Connect Repo
```

Select:

```text
Via HTTPS
```

Repository URL:

```text
https://github.com/Nadheer18/retailsphere.git
```

---

# Step 4 – Authentication

If the repository is Public:

```text
Connection Method: HTTPS

Username: (blank)

Password: (blank)
```

Click:

```text
Connect
```

---

# Step 5 – Verify Repository

You should see the repository listed and marked:

```text
Successful
```

with a green status indicator.

---

# Alternative CLI Verification

If needed:

```bash
kubectl exec -it \
-n argocd \
deployment/argocd-server -- sh
```

But for this project, the UI is sufficient.

---

# Step 6 – Confirm Helm Chart Path

The chart path ArgoCD will use is:

```text
helm/retailsphere
```

This must contain:

```text
Chart.yaml
values.yaml
templates/
```

Verify:

```bash
ls -l helm/retailsphere
```

---

# Step 7 – Verify Namespace

```bash
kubectl get ns
```

Ensure:

```text
retailsphere
```

exists.

If not:

```bash
kubectl create namespace retailsphere
```

---

# Phase 9.3 Completion Criteria

✅ ArgoCD UI accessible

✅ GitHub repository connected

✅ Repository status shows Successful

✅ Helm chart exists in `helm/retailsphere`

✅ `retailsphere` namespace exists

---

# Next Phase (9.4)

We will create the ArgoCD Application:

```text
RetailSphere Application
      ↓
Git Repository
      ↓
Helm Chart
      ↓
Kubernetes Cluster
```

This is where ArgoCD begins managing deployments and becomes the source of truth for your cluster.
