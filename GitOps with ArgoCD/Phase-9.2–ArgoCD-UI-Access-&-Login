## Phase 9.2 – ArgoCD UI Access & Login

Assuming ArgoCD installation is complete and all pods are Running.

---

## Step 1 – Check ArgoCD Pods

```bash
kubectl get pods -n argocd
```

Expected:

```bash
NAME                                      READY   STATUS
argocd-application-controller-xxxxx       1/1     Running
argocd-applicationset-controller-xxxxx    1/1     Running
argocd-dex-server-xxxxx                   1/1     Running
argocd-notifications-controller-xxxxx     1/1     Running
argocd-redis-xxxxx                        1/1     Running
argocd-repo-server-xxxxx                  1/1     Running
argocd-server-xxxxx                       1/1     Running
```

---

## Step 2 – Check Service

```bash
kubectl get svc -n argocd
```

You should see:

```bash
NAME            TYPE        CLUSTER-IP
argocd-server   ClusterIP   xxx.xxx.xxx.xxx
```

---

## Step 3 – Expose ArgoCD Server

Convert service to NodePort:

```bash
kubectl patch svc argocd-server \
-n argocd \
-p '{"spec":{"type":"NodePort"}}'
```

Verify:

```bash
kubectl get svc -n argocd
```

Example output:

```bash
NAME            TYPE       CLUSTER-IP
argocd-server   NodePort   10.96.x.x
```

Get full port details:

```bash
kubectl describe svc argocd-server -n argocd
```

Look for:

```bash
Port:       https 443/TCP
NodePort:   https 30443/TCP
```

Your NodePort may differ.

---

## Step 4 – Get Master Node Public IP

```bash
kubectl get nodes -o wide
```

Or from AWS console, note the Public IP of your control-plane/master node.

Example:

```text
13.xx.xx.xx
```

---

## Step 5 – Open Security Group

In AWS, ensure the Kubernetes master node Security Group allows:

| Type       | Port  |
| ---------- | ----- |
| Custom TCP | 30443 |

Source:

```text
0.0.0.0/0
```

For learning/lab purposes.

---

## Step 6 – Retrieve Initial Admin Password

```bash
kubectl get secret argocd-initial-admin-secret \
-n argocd \
-o jsonpath="{.data.password}" | base64 -d
```

Example:

```text
R8hKj2LmPq9Z
```

Save it.

---

## Step 7 – Access ArgoCD UI

Open:

```text
https://<MASTER_PUBLIC_IP>:30443
```

Example:

```text
https://13.xx.xx.xx:30443
```

Browser warning:

```text
Your connection is not private
```

Click:

```text
Advanced
Proceed
```

This is normal because ArgoCD uses a self-signed certificate initially.

---

## Step 8 – Login

Username:

```text
admin
```

Password:

```text
<password from secret>
```

---

## Step 9 – Change Admin Password (Recommended)

After login:

```text
User Icon
→ Change Password
```

Set a secure password.

---

## Verification

After login you should see the ArgoCD dashboard with:

```text
Applications
Repositories
Settings
Clusters
Projects
```

confirm whether the ArgoCD UI opens successfully in your browser. Then we'll proceed to Phase 9.3 – Register RetailSphere Git Repository in ArgoCD.

and confirm whether the ArgoCD UI opens successfully in your browser. Then we'll proceed to **Phase 9.3 – Register RetailSphere Git Repository in ArgoCD**.
