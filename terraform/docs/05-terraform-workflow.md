# Phase 2 – Terraform Workflow

## Overview

Terraform follows a structured workflow for creating, updating, and managing infrastructure.

A DevOps Engineer typically executes the following lifecycle:

```text
Write Code
    ↓
Format Code
    ↓
Validate Code
    ↓
Initialize Terraform
    ↓
Generate Plan
    ↓
Apply Changes
    ↓
Verify Infrastructure
    ↓
Manage State
    ↓
Update Infrastructure
    ↓
Destroy Infrastructure (Optional)
```

This workflow ensures infrastructure is deployed safely, consistently, and predictably.

---

# RetailSphere Terraform Workflow

For the RetailSphere project, Terraform is used to provision:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* Route Tables
* Security Groups
* IAM Roles
* IAM Instance Profiles
* Bastion Server
* Jenkins Server
* Infrastructure Server
* Developer Servers
* Kubeadm Cluster Nodes

---

# Step 1 – Write Terraform Code

Infrastructure is defined using HCL (HashiCorp Configuration Language).

Example:

```hcl
resource "aws_instance" "jenkins" {
  ami           = data.aws_ssm_parameter.ubuntu.value
  instance_type = "t3.medium"
}
```

Files typically include:

```text
main.tf
variables.tf
outputs.tf
provider.tf
terraform.tfvars
```

---

# Step 2 – Format Code

Terraform provides automatic formatting.

Command:

```bash
terraform fmt -recursive
```

Purpose:

* Consistent code style
* Easier reviews
* Professional formatting

Example:

Before:

```hcl
resource "aws_vpc" "main"{
cidr_block="10.0.0.0/16"
}
```

After:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

---

# Step 3 – Validate Configuration

Checks syntax and configuration errors.

Command:

```bash
terraform validate
```

Example Output:

```text
Success! The configuration is valid.
```

Benefits:

* Detects syntax mistakes
* Detects missing variables
* Detects invalid references

---

# Step 4 – Initialize Terraform

Downloads providers and initializes backend configuration.

Command:

```bash
terraform init
```

Example:

```text
Initializing provider plugins...
Initializing backend...
```

Downloads:

* AWS Provider
* Required modules
* Backend configuration

Run again when:

* New provider added
* Backend changed
* Module source changed

---

# Step 5 – Review Execution Plan

Terraform calculates changes without making them.

Command:

```bash
terraform plan
```

Example:

```text
Plan: 5 to add, 2 to change, 0 to destroy.
```

Benefits:

* Safe preview
* Detect unintended changes
* Review before deployment

---

# Save Plan File

Command:

```bash
terraform plan -out=tfplan
```

Creates:

```text
tfplan
```

Benefits:

* Approved plan can be reused
* Ensures exact deployment

---

# Step 6 – Apply Infrastructure

Deploy resources to AWS.

Command:

```bash
terraform apply
```

Terraform asks:

```text
Do you want to perform these actions?
```

Answer:

```text
yes
```

Or:

```bash
terraform apply -auto-approve
```

---

# RetailSphere Example

Terraform creates:

```text
VPC
Subnets
Security Groups
IAM Roles
EC2 Instances
```

Example Output:

```text
Apply complete!
Resources: 35 added, 0 changed, 0 destroyed.
```

---

# Step 7 – Verify Resources

Verify resources using Terraform outputs.

Command:

```bash
terraform output
```

Example:

```text
jenkins_url = "http://65.0.101.100:8080"
```

Specific output:

```bash
terraform output public_ips
```

Example:

```text
developer-01 = 3.110.xxx.xxx
developer-02 = 52.66.xxx.xxx
```

---

# Step 8 – Connect to Resources

Example SSH:

```bash
ssh -i mumbai-region.pem ubuntu@13.206.xxx.xxx
```

Verify:

* Bastion Server
* Jenkins Server
* Infra Server
* Kubernetes Nodes

---

# Step 9 – Modify Infrastructure

Infrastructure requirements change over time.

Examples:

* Add Developer Server
* Increase Volume Size
* Add Security Group Rules
* Create Additional Workers

Modify Terraform code.

Then execute:

```bash
terraform plan
```

Review changes.

Apply:

```bash
terraform apply
```

---

# Step 10 – Scale Infrastructure

RetailSphere supports scaling through variables.

Example:

```hcl
node_count = 10
```

Change:

```hcl
node_count = 15
```

Terraform detects additional resources.

Example:

```text
Plan: 5 to add, 0 to change, 0 to destroy.
```

---

# Step 11 – Review Current State

List resources:

```bash
terraform state list
```

Example:

```text
module.vpc.aws_vpc.this
module.ec2.aws_instance.jenkins
module.kubeadm.aws_instance.kubeadm_worker
```

---

# Step 12 – Inspect Resource Details

Command:

```bash
terraform state show RESOURCE_NAME
```

Example:

```bash
terraform state show module.ec2.aws_instance.jenkins
```

Useful for:

* Debugging
* Verification
* Auditing

---

# Step 13 – Refresh Infrastructure State

Check actual AWS resources.

Command:

```bash
terraform refresh
```

Purpose:

* Detect drift
* Sync state

---

# Step 14 – Destroy Infrastructure

Remove all resources.

Command:

```bash
terraform destroy
```

Preview:

```bash
terraform plan -destroy
```

Example:

```text
Destroy complete!
Resources: 35 destroyed.
```

Use carefully.

---

# Daily DevOps Workflow

Most common commands:

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

These commands are used almost every day by DevOps Engineers.

---

# RetailSphere Deployment Workflow

```text
Developer
    |
    v
Terraform Code
    |
    v
terraform fmt
    |
    v
terraform validate
    |
    v
terraform init
    |
    v
terraform plan
    |
    v
terraform apply
    |
    v
AWS Infrastructure
    |
    +--> VPC
    +--> Subnets
    +--> Security Groups
    +--> IAM
    +--> Jenkins
    +--> Infra Server
    +--> Developer Servers
    +--> Kubeadm Cluster
```

---

# Best Practices

## Always Review Plans

Never run:

```bash
terraform apply -auto-approve
```

in production environments.

---

## Use Variables

Avoid hardcoding values.

Use:

```hcl
variable "instance_type" {}
```

instead of:

```hcl
instance_type = "t3.medium"
```

---

## Use Remote State

Store state in:

```text
S3
```

Lock using:

```text
DynamoDB
```

---

## Commit Only Code

Commit:

```text
*.tf
README.md
docs/
```

Do NOT commit:

```text
terraform.tfstate
.terraform/
*.pem
```

---

# Summary

Terraform workflow is the operational lifecycle used to create, modify, and manage infrastructure.

RetailSphere follows this workflow:

```text
Write
→ Format
→ Validate
→ Init
→ Plan
→ Apply
→ Verify
→ Manage State
→ Scale
→ Destroy
```

Following this process ensures infrastructure remains predictable, repeatable, secure, and production-ready.
