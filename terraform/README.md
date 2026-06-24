# RetailSphere Terraform Infrastructure

## Overview

This directory contains the Infrastructure as Code (IaC) implementation for the RetailSphere project using Terraform.

Terraform is used to provision and manage AWS infrastructure in a consistent, repeatable, and automated manner.

The infrastructure follows a modular design approach and supports environment-specific deployments.

---

## Objectives

* Provision AWS infrastructure automatically
* Maintain infrastructure as code
* Enable repeatable deployments
* Support multi-environment architecture
* Reduce manual configuration effort
* Prepare infrastructure for Kubernetes, CI/CD, and GitOps

---

## Infrastructure Components

### Networking

* VPC
* Public Subnets
* Private Subnets
* Route Tables
* Internet Gateway

### Security

* Security Groups
* IAM Roles
* IAM Instance Profiles

### Compute

* Bastion Server
* Jenkins Server
* Infrastructure Server
* Developer Servers
* Kubeadm Master Node
* Kubeadm Worker Nodes

---

## Module Structure

```text
modules/
├── vpc/
├── security-groups/
├── iam/
├── ec2/
└── kubeadm/
```

Each module is responsible for a specific infrastructure component and can be managed independently.

---

## Environment Structure

```text
environments/
└── dev/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── backend.tf
    └── terraform.tfvars
```

Environment folders define deployment-specific configurations while reusing common modules.

---

## Terraform Workflow

Initialize Terraform:

```bash
terraform init
```

Validate Configuration:

```bash
terraform validate
```

Generate Execution Plan:

```bash
terraform plan
```

Deploy Infrastructure:

```bash
terraform apply
```

Destroy Infrastructure:

```bash
terraform destroy
```

---

## Outputs

Terraform provides useful outputs such as:

* Public IP Addresses
* Private IP Addresses
* Jenkins URL
* SSH Connection Commands
* Kubernetes Cluster Node Information

---

## Documentation

Detailed documentation is available in the `docs` directory.

```text
docs/
├── 01-phase2-study-guide.md
├── 02-terraform-architecture.md
├── 03-modules-explained.md
├── 04-state-management.md
├── 05-terraform-workflow.md
├── 06-troubleshooting.md
├── 07-production-improvements.md
└── 08-phase2-summary.md
```

---

## Project Phase

RetailSphere DevOps Project

Phase 2 – Terraform Infrastructure Automation

---

## Technologies Used

* Terraform
* AWS
* IAM
* EC2
* VPC
* Security Groups
* S3 Backend
* DynamoDB State Locking

---

## Author

Nadheer KV

RetailSphere Enterprise DevOps Project
