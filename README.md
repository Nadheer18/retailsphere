# RetailSphere — Phase 2: Infrastructure as Code (Terraform)

## Overview

Terraform-managed AWS infrastructure for RetailSphere. Remote state in S3, locking via DynamoDB, modular design across dev/staging/prod environments.

---

## Folder Structure

```
retailsphere-terraform/
├── .gitignore
├── README.md
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── staging/
│   │   └── (same as dev)
│   └── prod/
│       └── (same as dev)
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security-groups/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── eks/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Step 1 — Clone Repository

```bash
git clone https://github.com/<your-github-username>/retailsphere.git
cd retailsphere
```

---

## Step 2 — Create Folder Structure

```bash
mkdir -p terraform/{environments/{dev,staging,prod},modules/{ec2,eks,iam,security-groups,vpc}} && \
touch terraform/environments/{dev,staging,prod}/{backend,main,provider,variables}.tf \
      terraform/environments/{dev,staging,prod}/terraform.tfvars \
      terraform/modules/{ec2,eks,iam,security-groups,vpc}/{main,variables,outputs}.tf \
      terraform/{.gitignore,README.md}
```

---

## Step 3 — Bootstrap Terraform Backend (Manual, One-Time)

> Terraform cannot manage its own backend bucket. Create these manually via AWS Console first.

### S3 Bucket

| Setting             | Value                          |
|---------------------|--------------------------------|
| Name                | `retailsphere-terraform-state` |
| Region              | `ap-south-1`                   |
| Versioning          | Enabled                        |
| Block Public Access | Enabled                        |
| Purpose             | Store Terraform state file     |

### DynamoDB Table

| Setting        | Value                                                       |
|----------------|-------------------------------------------------------------|
| Name           | `retailsphere-terraform-locks`                              |
| Partition Key  | `LockID` (String)                                           |
| Billing Mode   | On-Demand                                                   |
| Purpose        | State locking (prevent concurrent `terraform apply`)        |

### Backend Config File

Path: `retailsphere-terraform/environments/dev/backend.tf`

---

## Step 4 — VPC Module

**Path:** `modules/vpc/`

### Network Design

```
VPC — retailsphere-Dev-vpc — 10.0.0.0/16
├── Public Subnet A   — retailsphere-public-a   — 10.0.1.0/24   (ap-south-1a)
├── Public Subnet B   — retailsphere-public-b   — 10.0.2.0/24   (ap-south-1b)
├── Private Subnet A  — retailsphere-private-a  — 10.0.11.0/24  (ap-south-1a)
├── Private Subnet B  — retailsphere-private-b  — 10.0.12.0/24  (ap-south-1b)
├── Internet Gateway  — retailsphere-igw
├── Public Route Table — retailsphere-public-rt — 0.0.0.0/0
└── Route Associations
```

### Variables (`modules/vpc/variables.tf`)

| Variable                | Description           |
|-------------------------|-----------------------|
| `vpc_cidr`              | VPC CIDR block        |
| `environment`           | Environment name      |
| `public_subnet_1_cidr`  | Public subnet A CIDR  |
| `public_subnet_2_cidr`  | Public subnet B CIDR  |
| `private_subnet_1_cidr` | Private subnet A CIDR |
| `private_subnet_2_cidr` | Private subnet B CIDR |

---

## Step 5 — Security Groups Module

**Path:** `modules/security-groups/`

| Security Group                    | Purpose                  |
|-----------------------------------|--------------------------|
| `retailsphere-jenkins-sg`         | Jenkins CI/CD server     |
| `retailsphere-infra-sg`           | Terraform/Ansible server |
| `retailsphere-developer-sg`       | Developer workstation    |
| `retailsphere-bastion-sg`         | Bastion SSH jump server  |
| `retailsphere-kubeadm-cluster-sg` | Self-managed K8s         |
| `retailsphere-eks-cluster-sg`     | EKS cluster              |

---

## Step 6 — IAM Module

**Path:** `modules/iam/`

### IAM Roles

| Role                         | Purpose                   |
|------------------------------|---------------------------|
| `RetailSphereJenkinsRole`    | Jenkins EC2               |
| `RetailSphereInfraRole`      | Terraform/Ansible EC2     |
| `RetailSphereDeveloperRole`  | Developer Workstation EC2 |
| `RetailSphereBastionRole`    | Bastion EC2               |
| `RetailSphereEKSClusterRole` | EKS Control Plane         |
| `RetailSphereEKSNodeRole`    | EKS Worker Nodes          |

### Resources in `modules/iam/main.tf`

- `retailsphere-jenkins-role`
- `retailsphere-infra-role`
- `retailsphere-developer-role`
- `retailsphere-eks-cluster-role`
- `retailsphere-eks-node-role`
- `retailsphere-jenkins-profile`
- `retailsphere-infra-profile`
- `retailsphere-developer-profile`
- `aws_iam_role_policy_attachment` (all roles)

---

## Step 7 — EC2 Module

**Path:** `modules/ec2/`

### Server Design

| Server    | Purpose               | Instance Type | IAM Profile       | Security Group |
|-----------|-----------------------|---------------|-------------------|----------------|
| Bastion   | SSH Jump Server       | t3.micro      | None              | Bastion SG     |
| Jenkins   | CI/CD + SonarQube     | t3.medium     | Jenkins Profile   | Jenkins SG     |
| Infra     | Terraform + Ansible   | t3.micro      | Infra Profile     | Infra SG       |
| Developer | Developer Workstation | t3.micro      | Developer Profile | Developer SG   |

### AMI Source (Ubuntu 24.04)

```hcl
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}
```

---

## Step 8 — Dev Environment Wiring

**Path:** `environments/dev/`

`main.tf` calls all modules: `vpc`, `security_groups`, `iam`, `ec2`

`terraform.tfvars` — set CIDR IPs per environment.

`backend.tf` — points to S3 bucket + DynamoDB table.

---

## Step 9 — Deploy

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## Current Status

| Resource               | Status |
|------------------------|--------|
| S3 Backend             | ✅     |
| DynamoDB State Locking | ✅     |
| Terraform Modules      | ✅     |
| VPC                    | ✅     |
| Public Subnets         | ✅     |
| Private Subnets        | ✅     |
| Internet Gateway       | ✅     |
| Route Tables           | ✅     |
| Security Groups        | ✅     |
| IAM Roles              | ✅     |
| IAM Instance Profiles  | ✅     |
| Jenkins EC2            | ✅     |
| Infra EC2              | ✅     |
| Developer EC2          | ✅     |
| State stored in S3     | ✅     |

---

## Common Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Downloads providers, initializes backend, prepares working directory |
| `terraform init -reconfigure` | Reconfigures backend settings |
| `terraform init -migrate-state` | Moves state to a new backend |
| `terraform fmt -recursive` | Formats all Terraform code |
| `terraform validate` | Validates syntax |
| `terraform plan` | Shows proposed changes |
| `terraform apply -auto-approve` | Applies changes automatically |
| `terraform apply tfplan` | Applies a saved plan file |
| `terraform state list` | Lists all managed resources |
| `terraform state pull` | Downloads current remote state |
| `dir terraform.tfstate*` | Shows local state files |

```bash
aws ec2 describe-vpcs --region ap-south-1 \
  --query "Vpcs[*].[VpcId,CidrBlock]" --output table
```

---

## Current Status

| Resource               | Status |
|------------------------|--------|
| S3 Backend             | ✅     |
| DynamoDB State Locking | ✅     |
| Terraform Modules      | ✅     |
| VPC                    | ✅     |
| Public Subnets         | ✅     |
| Private Subnets        | ✅     |
| Internet Gateway       | ✅     |
| Route Tables           | ✅     |
| Security Groups        | ✅     |
| IAM Roles              | ✅     |
| IAM Instance Profiles  | ✅     |
| Bastion EC2            | ✅     |
| Developer EC2          | ✅     |
| Infra EC2              | ✅     |
| Jenkins EC2            | ✅     |
| Remote State Management| ✅     |

---

## Upcoming Terraform Components (Phase 3+)

| Component | Category |
|-----------|----------|
| NAT Gateway | Networking |
| Elastic IP | Networking |
| Application Load Balancer | Networking |
| Kubeadm Master Node (×1) | Kubernetes |
| Kubeadm Worker Nodes (×2) | Kubernetes |
| Amazon EKS | Kubernetes |
| Auto Scaling Groups | Compute |
| Route53 | DNS |
| ACM Certificates | Security |
| RDS | Database |
| CloudWatch Monitoring | Observability |
| SNS Notifications | Observability |

---

## Interview Q&A

**Q: How did you manage Terraform state?**
> Remote state stored in S3 with versioning enabled. State locking via DynamoDB prevents concurrent `terraform apply` runs.

**Q: Why use an S3 backend?**
> Centralizes state management, enables team collaboration, and maintains version history.

**Q: Why is DynamoDB used with Terraform?**
> Provides state locking — prevents concurrent Terraform operations from corrupting state.

**Q: What are Terraform modules?**
> Reusable Terraform components that reduce duplication and improve maintainability.

**Q: Difference between `terraform plan` and `terraform apply`?**
> `plan` previews changes. `apply` executes them.

**Q: Why use IAM Roles instead of Access Keys?**
> Roles provide temporary credentials automatically — no keys stored on servers.

**Q: What is Terraform State?**
> Mapping file that tracks all resources created and managed by Terraform.

**Q: How did you obtain the latest Ubuntu AMI?**
> Via AWS SSM Parameter Store — dynamically retrieves latest Ubuntu 24.04 AMI ID.

**Q: Benefits of Infrastructure as Code?**
> Infrastructure becomes repeatable, version-controlled, auditable, and reproducible.

**Q: Why create reusable modules?**
> Improves scalability, maintainability, consistency, and reusability across environments.