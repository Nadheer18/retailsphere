# Phase 2 – Terraform Infrastructure Study Guide

## Introduction

Phase 2 of the RetailSphere project focuses on Infrastructure as Code (IaC) using Terraform.

The purpose of this phase is to automate AWS infrastructure provisioning and establish the cloud foundation required for the remaining project phases.

Instead of manually creating AWS resources through the AWS Console, Terraform allows infrastructure to be defined in code and deployed automatically.

---

# What is Infrastructure as Code (IaC)?

Infrastructure as Code is the practice of managing and provisioning infrastructure through code instead of manual processes.

Benefits include:

* Automation
* Consistency
* Reusability
* Version Control
* Faster Deployments
* Reduced Human Error

Example:

Instead of manually creating:

* VPC
* Subnets
* EC2 Instances
* Security Groups
* IAM Roles

Terraform creates everything automatically using configuration files.

---

# What is Terraform?

Terraform is an open-source Infrastructure as Code tool developed by HashiCorp.

Terraform allows engineers to:

* Define infrastructure using code
* Create resources automatically
* Update infrastructure safely
* Destroy infrastructure when no longer needed
* Maintain infrastructure state

Terraform uses a declarative approach.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

Terraform determines how to create the resource automatically.

---

# Why Terraform for RetailSphere?

RetailSphere is designed as a cloud-native application.

Before deploying applications, we require:

* Networking
* Security
* Compute Resources
* Kubernetes Infrastructure
* CI/CD Infrastructure

Terraform provides:

* Automated Infrastructure Deployment
* Repeatable Environments
* Easy Disaster Recovery
* Team Collaboration
* Infrastructure Version Control

---

# Phase 2 Objectives

The primary objectives of Phase 2 are:

* Build AWS Networking
* Configure Security Groups
* Create IAM Roles
* Deploy EC2 Instances
* Create Kubernetes Infrastructure
* Implement Remote State Management
* Build Modular Terraform Architecture

---

# Infrastructure Created

Terraform provisions the following infrastructure:

## Networking

* 1 VPC
* 2 Public Subnets
* 2 Private Subnets
* 1 Internet Gateway
* Route Tables
* Route Table Associations

## Security

* Bastion Security Group
* Jenkins Security Group
* Developer Security Group
* Kubernetes Security Group

## Identity and Access Management

* Developer IAM Role
* Infrastructure IAM Role
* Jenkins IAM Role
* EKS Cluster Role
* EKS Worker Role

## Compute Resources

* Bastion Host
* Jenkins Server
* Infrastructure Server
* Developer Servers
* Kubernetes Master Node
* Kubernetes Worker Nodes

---

# Terraform Modules Used

To maintain a professional structure, infrastructure was divided into reusable modules.

## VPC Module

Responsible for:

* VPC Creation
* Subnets
* Internet Gateway
* Route Tables

## Security Group Module

Responsible for:

* Network Access Rules
* Inbound Traffic Control
* Outbound Traffic Control

## IAM Module

Responsible for:

* IAM Roles
* IAM Policies
* Instance Profiles

## EC2 Module

Responsible for:

* Bastion Server
* Jenkins Server
* Infrastructure Server
* Developer Servers

## Kubeadm Module

Responsible for:

* Kubernetes Master Node
* Kubernetes Worker Nodes

---

# Terraform Workflow

Terraform follows a predictable workflow.

### Initialize

```bash
terraform init
```

Downloads providers and initializes Terraform.

### Validate

```bash
terraform validate
```

Checks configuration syntax.

### Format

```bash
terraform fmt
```

Formats Terraform code.

### Plan

```bash
terraform plan
```

Displays proposed changes.

### Apply

```bash
terraform apply
```

Creates or updates infrastructure.

### Destroy

```bash
terraform destroy
```

Removes infrastructure.

---

# Remote State Management

Terraform stores infrastructure information in a state file.

Example:

```text
terraform.tfstate
```

Remote state management provides:

* Shared State
* Team Collaboration
* State Locking
* Disaster Recovery

RetailSphere uses:

* Amazon S3
* DynamoDB Locking

---

# Key Files Learned

## main.tf

Contains resource definitions.

## variables.tf

Contains input variables.

## outputs.tf

Displays useful deployment information.

## provider.tf

Defines cloud provider configuration.

## terraform.tfvars

Stores environment-specific values.

## backend.tf

Defines remote state storage configuration.

---

# Skills Learned During Phase 2

By completing this phase, the following skills were gained:

* Terraform Fundamentals
* Infrastructure as Code
* AWS Networking
* VPC Design
* Subnet Planning
* Security Group Configuration
* IAM Management
* EC2 Provisioning
* Kubernetes Infrastructure Preparation
* Terraform Modules
* Terraform State Management
* Remote Backend Configuration

---

# Business Value

Phase 2 establishes the cloud infrastructure foundation required for all future project phases.

Without this phase:

* Ansible cannot configure servers
* Applications cannot be deployed
* Kubernetes cannot be installed
* Jenkins cannot perform CI/CD
* ArgoCD cannot perform GitOps

Terraform becomes the single source of truth for RetailSphere infrastructure.

---

# Phase 2 Outcome

At the end of Phase 2, RetailSphere has a fully automated AWS infrastructure environment that is:

* Repeatable
* Scalable
* Secure
* Version Controlled
* Production Ready

This infrastructure serves as the foundation for:

* Phase 3 – Ansible Configuration Management
* Phase 4 – Application Development
* Phase 5 – Containerization
* Phase 6 – Kubernetes Deployment
* Phase 7 – Jenkins CI/CD
* Phase 8 – Helm Packaging
* Phase 9 – GitOps with ArgoCD
