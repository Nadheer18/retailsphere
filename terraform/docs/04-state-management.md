# Phase 2 – Terraform State Management

## Overview

Terraform uses a state file to keep track of infrastructure resources it creates and manages.

Without a state file, Terraform would not know:

* What resources already exist
* What changes need to be made
* What resources should be updated
* What resources should be destroyed

State management is a critical component of Infrastructure as Code (IaC).

---

# What is Terraform State?

Terraform stores infrastructure information in a file called:

```text
terraform.tfstate
```

This file acts as Terraform's database.

Terraform records information such as:

* Resource IDs
* Resource Names
* Public IP Addresses
* Private IP Addresses
* Security Groups
* Subnets
* IAM Roles
* Dependencies

---

# Why Terraform Needs State

Consider the following example:

```hcl
resource "aws_instance" "jenkins" {
  instance_type = "t3.medium"
}
```

When Terraform creates this instance, AWS generates:

* Instance ID
* Public IP
* Private IP

Terraform stores this information inside the state file.

Example:

```text
i-0123456789abcdef
13.234.37.23
10.0.1.50
```

Without state information Terraform would create duplicate resources every time.

---

# Local State

By default Terraform stores state locally.

Example:

```text
terraform.tfstate
```

Location:

```text
environments/dev/
├── terraform.tfstate
```

Advantages:

* Simple
* Easy for learning

Disadvantages:

* Not suitable for teams
* Can be lost accidentally
* No locking mechanism
* Difficult collaboration

---

# Remote State

In enterprise environments, state files should never remain only on a local machine.

Instead, Terraform stores state remotely.

Benefits:

* Team Collaboration
* Centralized State
* State Backup
* Versioning
* Security
* State Locking

---

# RetailSphere Remote State Architecture

```text
Terraform
     |
     v
S3 Bucket
     |
     v
terraform.tfstate
     |
     v
DynamoDB Lock Table
```

---

# How to Create S3 Bucket for Terraform State

You can create an S3 bucket using AWS CLI, Terraform, or manually using the AWS Console UI.

---

## Using AWS Console (Manual Method)

1. Login to AWS Management Console
2. Navigate to **S3 Service**
3. Click **Create Bucket**
4. Enter bucket name:

   ```text
   retailsphere-terraform-state
   ```
5. Select region:

   ```text
   ap-south-1
   ```
6. Keep **Block Public Access enabled**
7. Enable **Bucket Versioning**
8. Enable **Default Encryption (AES-256 or KMS)**
9. Click **Create Bucket**

---

## Using AWS CLI

```bash
aws s3api create-bucket \
  --bucket retailsphere-terraform-state \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

Enable versioning:

```bash
aws s3api put-bucket-versioning \
  --bucket retailsphere-terraform-state \
  --versioning-configuration Status=Enabled
```

Enable encryption:

```bash
aws s3api put-bucket-encryption \
  --bucket retailsphere-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

---

## Using Terraform

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "retailsphere-terraform-state"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

---

# How to Create DynamoDB Table for State Locking

---

## Using AWS Console (Manual Method)

1. Login to AWS Management Console
2. Navigate to **DynamoDB Service**
3. Click **Create Table**
4. Enter table name:

   ```text
   retailsphere-terraform-locks
   ```
5. Partition key:

   ```text
   LockID (String)
   ```
6. Select **On-demand (PAY_PER_REQUEST)** billing mode
7. Leave other settings as default
8. Click **Create Table**

---

## Using AWS CLI

```bash
aws dynamodb create-table \
  --table-name retailsphere-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

---

## Using Terraform

```hcl
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "retailsphere-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

---

# Amazon S3 Backend

Amazon S3 stores the Terraform state file.

Example:

```text
retailsphere-terraform-state
```

Stored Object:

```text
terraform/dev/terraform.tfstate
```

Benefits:

* Durable
* Highly Available
* Versioning Support
* Secure Storage

---

# Backend Configuration

Example:

```hcl
terraform {
  backend "s3" {
    bucket         = "retailsphere-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "retailsphere-terraform-locks"
  }
}
```

Explanation:

| Parameter      | Purpose         |
| -------------- | --------------- |
| bucket         | S3 bucket name  |
| key            | State file path |
| region         | AWS region      |
| dynamodb_table | Locking table   |

---

# DynamoDB State Locking

When multiple engineers work on the same infrastructure, conflicts can occur.

Example:

```text
Engineer A -> terraform apply
Engineer B -> terraform apply
```

Both changes running simultaneously may corrupt the state.

DynamoDB prevents this.

---

# Locking Process

```text
User
  |
terraform apply
  |
Lock Acquired
  |
State Updated
  |
Lock Released
```

Only one Terraform operation can run at a time.

---

# State Lock Example

During execution:

```bash
terraform apply
```

Terraform displays:

```text
Acquiring state lock...
```

After completion:

```text
Releasing state lock...
```

---

# State File Contents

The state file contains:

```text
Resources
Outputs
Dependencies
Metadata
Provider Information
```

Example Resources:

```text
VPC
Subnets
EC2 Instances
Security Groups
IAM Roles
```

---

# Sensitive Information Warning

State files may contain sensitive data.

Examples:

* Passwords
* Resource IDs
* Internal IP Addresses
* Database Endpoints
* Access Information

Never commit state files to GitHub.

---

# Git Ignore Configuration

RetailSphere excludes state files using:

```gitignore
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
```

This prevents accidental exposure of infrastructure information.

---

# State Commands

## View State Resources

```bash
terraform state list
```

Example Output:

```text
module.vpc.aws_vpc.this
module.ec2.aws_instance.jenkins
module.ec2.aws_instance.infra
```

---

## Show Resource Details

```bash
terraform state show RESOURCE_NAME
```

Example:

```bash
terraform state show module.ec2.aws_instance.jenkins
```

---

## Pull Remote State

```bash
terraform state pull
```

Downloads the current state.

---

## Push State

```bash
terraform state push terraform.tfstate
```

Uploads state manually.

Use carefully.

---

## Remove Resource from State

```bash
terraform state rm RESOURCE_NAME
```

Example:

```bash
terraform state rm module.ec2.aws_instance.jenkins
```

Removes resource from state without deleting it in AWS.

---

## Move Resource State

```bash
terraform state mv
```

Used when refactoring modules.

---

# State Recovery

If the state file is lost:

Terraform may lose track of resources.

Recovery options:

### Restore from S3 Versioning

```text
S3 Bucket
   |
Previous Version
   |
Restore
```

---

### Import Existing Resources

Example:

```bash
terraform import aws_instance.jenkins i-0123456789abcdef
```

Terraform reconnects to existing infrastructure.

---

# State Backup Strategy

Recommended:

```text
S3 Versioning Enabled
Daily Backups
Restricted Access
Encryption Enabled
```

Benefits:

* Disaster Recovery
* Historical Tracking
* Rollback Capability

---

# Security Best Practices

## Enable S3 Versioning

Protects against accidental deletion.

---

## Enable Encryption

Protects stored state data.

Example:

```text
AES-256
KMS Encryption
```

---

## Restrict Access

Only authorized engineers should access state.

Use:

* IAM Policies
* IAM Roles
* Least Privilege Principle

---

## Never Share State Files

Avoid:

```text
Email
WhatsApp
Public Repositories
Shared Drives
```

---

# Common State Issues

## State Lock Error

Example:

```text
Error acquiring the state lock
```

Solution:

```bash
terraform force-unlock LOCK_ID
```

---

## State Drift

Occurs when resources are modified manually in AWS.

Example:

```text
Terraform State ≠ Actual Infrastructure
```

Solution:

```bash
terraform refresh
```

or

```bash
terraform plan
```

to detect differences.

---

## Missing State File

Symptoms:

```text
Terraform wants to recreate everything
```

Cause:

State file deleted or unavailable.

Solution:

* Restore from S3
* Import resources

---

# RetailSphere State Management Design

RetailSphere follows the following state strategy:

```text
Terraform
    |
    v
S3 Backend
    |
    v
Terraform State
    |
    v
DynamoDB Locking
```

This approach provides:

* Centralized State Management
* Secure Storage
* Team Collaboration
* State Protection
* Enterprise Scalability

---

# Summary

Terraform state management is responsible for tracking all infrastructure resources created by Terraform.

In RetailSphere:

* S3 stores state files
* DynamoDB provides locking
* Git ignores state files
* State is protected and centralized

Proper state management ensures safe, reliable, and scalable infrastructure operations throughout the RetailSphere project lifecycle.
