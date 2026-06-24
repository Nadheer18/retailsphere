# Phase 2 – Terraform Infrastructure Architecture

## Overview

This document describes the AWS infrastructure architecture provisioned during Phase 2 of the RetailSphere project using Terraform.

The objective of this architecture is to provide a secure, scalable, and automated cloud foundation for application deployment, Kubernetes, CI/CD, and GitOps workflows.

---

# High-Level Architecture

```text
Internet
    |
    v
Internet Gateway
    |
    v
RetailSphere VPC (10.0.0.0/16)
│
├── Public Subnet A (10.0.1.0/24)
│   ├── Bastion Host
│   ├── Jenkins Server
│   ├── Infrastructure Server
│   ├── Developer Servers
│   ├── Kubernetes Master
│   └── Kubernetes Workers
│
├── Public Subnet B (10.0.2.0/24)
│
├── Private Subnet A (10.0.11.0/24)
│
└── Private Subnet B (10.0.12.0/24)
```

---

# AWS Region

All resources are deployed in:

```text
ap-south-1 (Mumbai)
```

This region was selected for:

* Lower latency
* Cost optimization
* Availability of required AWS services

---

# VPC Architecture

## Virtual Private Cloud

The VPC provides logical network isolation for all RetailSphere resources.

Configuration:

```text
VPC CIDR: 10.0.0.0/16
```

Benefits:

* Network segmentation
* Security isolation
* Controlled communication
* Scalability

---

# Subnet Design

## Public Subnet A

```text
10.0.1.0/24
```

Purpose:

* Bastion Host
* Jenkins Server
* Infrastructure Server
* Developer Servers
* Kubernetes Cluster

---

## Public Subnet B

```text
10.0.2.0/24
```

Purpose:

* High Availability expansion
* Future workloads

---

## Private Subnet A

```text
10.0.11.0/24
```

Purpose:

* Databases
* Internal services
* Future workloads

---

## Private Subnet B

```text
10.0.12.0/24
```

Purpose:

* Disaster recovery
* High availability services

---

# Internet Connectivity

## Internet Gateway

An Internet Gateway is attached to the VPC.

Purpose:

* Public internet access
* Inbound connectivity
* Outbound connectivity

Traffic Flow:

```text
EC2 Instance
     |
Route Table
     |
Internet Gateway
     |
Internet
```

---

# Route Tables

Public Route Table:

```text
0.0.0.0/0
    |
Internet Gateway
```

Purpose:

* Allow internet access from public subnets

Associated With:

* Public Subnet A
* Public Subnet B

---

# Security Architecture

Security Groups provide instance-level firewall protection.

---

## Bastion Security Group

Allowed Ports:

```text
22/TCP
```

Purpose:

* Secure SSH access

---

## Jenkins Security Group

Allowed Ports:

```text
22/TCP
8080/TCP
9000/TCP
```

Purpose:

* SSH
* Jenkins Dashboard
* SonarQube

---

## Developer Security Group

Allowed Ports:

```text
22/TCP
8080/TCP
```

Purpose:

* SSH Access
* Application Testing

---

## Kubernetes Cluster Security Group

Allowed Ports:

```text
22/TCP
80/TCP
443/TCP
6443/TCP
10250/TCP
30000-32767/TCP
8472/UDP
```

Purpose:

* Kubernetes API
* Kubelet Communication
* NodePort Services
* Flannel Networking

---

# IAM Architecture

IAM Roles are used instead of storing AWS credentials directly on servers.

Benefits:

* Improved security
* Temporary credentials
* Least privilege access

---

## Developer Role

Purpose:

* Systems Manager Access

Policy:

```text
AmazonSSMManagedInstanceCore
```

---

## Infrastructure Role

Purpose:

* Infrastructure management

Policy:

```text
AdministratorAccess
```

---

## Jenkins Role

Purpose:

* CI/CD operations

Policies:

```text
AmazonEC2ContainerRegistryPowerUser
AmazonEKSClusterPolicy
AmazonS3ReadOnlyAccess
```

---

## EKS Cluster Role

Purpose:

* Kubernetes control plane permissions

Policy:

```text
AmazonEKSClusterPolicy
```

---

## EKS Node Role

Purpose:

* Worker node permissions

Policies:

```text
AmazonEKSWorkerNodePolicy
AmazonEKS_CNI_Policy
AmazonEC2ContainerRegistryReadOnly
```

---

# Compute Architecture

Terraform provisions all EC2 infrastructure automatically.

---

## Bastion Host

Purpose:

* Secure entry point
* SSH gateway

Responsibilities:

* Administrative access

---

## Jenkins Server

Purpose:

* Continuous Integration
* Continuous Deployment

Responsibilities:

* Build automation
* Testing automation
* Deployment automation

---

## Infrastructure Server

Purpose:

* Terraform execution
* Ansible execution

Installed Software:

* Git
* Ansible

Responsibilities:

* Infrastructure management
* Configuration management

---

## Developer Servers

Purpose:

* Application development
* Testing
* Validation

Responsibilities:

* Development environment

---

# Kubernetes Architecture

The infrastructure includes a kubeadm-based Kubernetes cluster.

---

## Kubernetes Master Node

Responsibilities:

* API Server
* Scheduler
* Controller Manager
* Cluster Management

Example:

```text
1 Master Node
```

---

## Kubernetes Worker Nodes

Responsibilities:

* Run Pods
* Run Containers
* Execute Workloads

Example:

```text
3 Worker Nodes
```

---

# Resource Communication Flow

```text
Developer
   |
   v
Bastion Host
   |
   v
Infrastructure Server
   |
   v
Kubernetes Cluster
   |
   v
Application Workloads
```

---

# CI/CD Deployment Flow

```text
GitHub
   |
   v
Jenkins
   |
   v
Docker
   |
   v
Kubernetes Cluster
   |
   v
RetailSphere Application
```

---

# GitOps Deployment Flow

```text
Git Repository
      |
      v
ArgoCD
      |
      v
Kubernetes Cluster
      |
      v
RetailSphere Application
```

---

# Scalability Considerations

The architecture is designed to support:

* Additional developer servers
* Additional worker nodes
* Multiple environments
* Production expansion
* High availability enhancements

Terraform variables allow infrastructure growth without redesigning the architecture.

---

# Architecture Outcome

The Terraform architecture provides:

* Automated Infrastructure Provisioning
* Secure AWS Networking
* Role-Based Access Control
* CI/CD Foundation
* Kubernetes Foundation
* GitOps Readiness
* Scalable Cloud Infrastructure

This architecture serves as the foundation for all remaining phases of the RetailSphere project.
