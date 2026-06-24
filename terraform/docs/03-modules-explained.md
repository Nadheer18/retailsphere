# Phase 2 – Terraform Modules Explained

## Overview

To maintain a scalable and professional Infrastructure as Code design, the RetailSphere Terraform project is divided into reusable modules.

A Terraform module is a collection of resources grouped together to perform a specific function.

Benefits of using modules:

* Reusability
* Maintainability
* Scalability
* Reduced Code Duplication
* Easier Troubleshooting
* Team Collaboration

---

# Module Architecture

```text
modules/
├── vpc
├── security-groups
├── iam
├── ec2
└── kubeadm
```

Each module has a dedicated responsibility.

---

# VPC Module

## Purpose

The VPC module creates the networking foundation for the entire RetailSphere infrastructure.

Without the VPC module, no AWS resources can communicate securely.

---

## Resources Created

* VPC
* Public Subnet A
* Public Subnet B
* Private Subnet A
* Private Subnet B
* Internet Gateway
* Route Table
* Route Table Associations

---

## Inputs

Examples:

```hcl
vpc_cidr
public_subnet_1_cidr
public_subnet_2_cidr
private_subnet_1_cidr
private_subnet_2_cidr
environment
```

---

## Outputs

Examples:

```hcl
vpc_id
public_subnet_id
private_subnet_ids
```

---

## Dependency Flow

```text
VPC Module
     |
     +---- Security Groups
     |
     +---- EC2 Instances
     |
     +---- Kubernetes Nodes
```

---

# Security Groups Module

## Purpose

This module controls network traffic between servers and external users.

Acts as a virtual firewall.

---

## Resources Created

### Bastion Security Group

Allowed:

```text
22/TCP
```

---

### Jenkins Security Group

Allowed:

```text
22/TCP
8080/TCP
9000/TCP
```

---

### Developer Security Group

Allowed:

```text
22/TCP
8080/TCP
```

---

### Kubernetes Cluster Security Group

Allowed:

```text
22/TCP
80/TCP
443/TCP
6443/TCP
10250/TCP
30000-32767/TCP
8472/UDP
```

---

## Inputs

Examples:

```hcl
vpc_id
```

---

## Outputs

Examples:

```hcl
bastion_sg_id
jenkins_sg_id
infra_sg_id
developer_sg_id
kubeadm_cluster_sg_id
```

---

## Dependency Flow

```text
Security Groups
        |
        +---- Bastion
        |
        +---- Jenkins
        |
        +---- Infra
        |
        +---- Developers
        |
        +---- Kubernetes
```

---

# IAM Module

## Purpose

Provides AWS permissions through IAM Roles and Instance Profiles.

Eliminates the need to store AWS Access Keys on servers.

---

## Resources Created

### IAM Roles

* Developer Role
* Infrastructure Role
* Jenkins Role
* EKS Cluster Role
* EKS Worker Role

---

### Instance Profiles

* Developer Profile
* Infrastructure Profile
* Jenkins Profile

---

### Policy Attachments

Examples:

```text
AmazonSSMManagedInstanceCore
AdministratorAccess
AmazonEKSClusterPolicy
AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
```

---

## Outputs

Examples:

```hcl
developer_instance_profile
infra_instance_profile
jenkins_instance_profile
```

---

## Dependency Flow

```text
IAM Module
      |
      +---- Jenkins
      |
      +---- Infra
      |
      +---- Developer
```

---

# EC2 Module

## Purpose

Creates all standard EC2 servers required by RetailSphere.

This module handles application infrastructure.

---

## Resources Created

### Bastion Host

Purpose:

* SSH Access
* Administrative Entry Point

---

### Jenkins Server

Purpose:

* CI/CD Automation
* Build Execution

---

### Infrastructure Server

Purpose:

* Terraform
* Ansible
* Infrastructure Operations

---

### Developer Servers

Purpose:

* Development
* Testing
* Application Validation

---

## Inputs

Examples:

```hcl
public_subnet_id
key_name

bastion_sg_id
jenkins_sg_id
infra_sg_id
developer_sg_id

developer_instance_profile
infra_instance_profile
jenkins_instance_profile

enable_bastion
enable_jenkins
enable_infra
enable_developer

node_count
```

---

## Outputs

Examples:

```hcl
public_ips
private_ips
ssh_commands
jenkins_url
```

---

## Special Features

### Conditional Deployment

Infrastructure can be enabled or disabled.

Example:

```hcl
enable_jenkins = true
enable_bastion = false
```

---

### Dynamic Scaling

Example:

```hcl
node_count = 3
```

Creates:

```text
Developer-01
Developer-02
Developer-03
```

---

# Kubeadm Module

## Purpose

Creates Kubernetes infrastructure using kubeadm.

This module is independent from the EC2 module to keep Kubernetes resources isolated.

---

## Resources Created

### Kubernetes Master Node

Purpose:

* API Server
* Scheduler
* Controller Manager

---

### Kubernetes Worker Nodes

Purpose:

* Run Containers
* Run Pods
* Execute Workloads

---

## Inputs

Examples:

```hcl
public_subnet_id
kubeadm_cluster_sg_id
key_name

enable_kubeadm_master
enable_kubeadm_worker

node_count
```

---

## Outputs

Examples:

```hcl
master_public_ip
master_private_ip

worker_public_ips
worker_private_ips
```

---

## Scaling Example

```hcl
node_count = 3
```

Result:

```text
1 Kubernetes Master
3 Kubernetes Workers
```

---

# Module Interaction Flow

```text
VPC Module
    |
    +---- Security Groups Module
    |
    +---- IAM Module
    |
    +---- EC2 Module
    |
    +---- Kubeadm Module
```

---

# Environment Layer

The environment directory acts as the orchestration layer.

Location:

```text
environments/dev
```

Responsibilities:

* Provider Configuration
* Variable Values
* Backend Configuration
* Module Calls
* Outputs

---

# Module Design Benefits

The modular design provides:

* Reusable Components
* Cleaner Code Structure
* Easier Maintenance
* Independent Scaling
* Better Team Collaboration
* Enterprise-Level Architecture

---

# Module Summary

| Module          | Responsibility             |
| --------------- | -------------------------- |
| vpc             | Networking Foundation      |
| security-groups | Traffic Control            |
| iam             | Permissions and Access     |
| ec2             | Application Infrastructure |
| kubeadm         | Kubernetes Infrastructure  |

Together, these modules create a complete AWS infrastructure platform for RetailSphere and provide the foundation for Ansible, Kubernetes, Jenkins, Helm, and ArgoCD in later phases.
