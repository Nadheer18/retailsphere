# Phase 2 – Troubleshooting Guide

## Overview

During Terraform development, engineers frequently encounter errors related to variables, modules, outputs, state files, AWS permissions, and infrastructure dependencies.

This document captures common Terraform issues encountered during the RetailSphere project and provides solutions for resolving them.

---

# Troubleshooting Workflow

Whenever Terraform fails:

```text
Read Error
    |
Identify Component
    |
Check Configuration
    |
Validate Code
    |
Plan Again
    |
Apply Again
```

Useful commands:

```bash
terraform validate
terraform plan
terraform apply
terraform state list
terraform output
```

---

# Issue 1 – Terraform Asking for Variables

Example:

```text
var.environment
Enter a value:
```

Cause:

Terraform variable exists but no value was supplied.

Example:

```hcl
variable "environment" {}
```

---

## Solution

Provide values inside:

```text
terraform.tfvars
```

Example:

```hcl
environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"

private_subnet_1_cidr = "10.0.11.0/24"
private_subnet_2_cidr = "10.0.12.0/24"
```

---

# Issue 2 – Invalid CIDR Block

Example:

```text
Error:
expected cidr_block to contain a valid value
```

Example Input:

```text
dev
```

Terraform expected:

```text
10.0.0.0/16
```

---

## Solution

Use valid CIDR notation.

Example:

```hcl
vpc_cidr = "10.0.0.0/16"
```

---

# Issue 3 – Module Output Not Found

Example:

```text
Unsupported attribute

module.ec2.developer_public_ip
```

Cause:

Output does not exist inside module.

---

## Solution

Verify module outputs.

Example:

```hcl
output "developer_public_ips" {
  value = aws_instance.developer[*].public_ip
}
```

Then reference:

```hcl
module.ec2.developer_public_ips
```

---

# Issue 4 – Reference to Undeclared Resource

Example:

```text
Reference to undeclared resource

aws_instance.developer
```

Cause:

Resource exists inside module, not root module.

---

## Incorrect

```hcl
output "developer_ips" {
  value = aws_instance.developer[*].public_ip
}
```

---

## Correct

```hcl
output "developer_ips" {
  value = module.ec2.developer_public_ips
}
```

---

# Issue 5 – Missing Module Output

Example:

```text
This object does not have an attribute
```

Cause:

Output not exported from module.

---

## Solution

Create output inside module.

Example:

```hcl
output "jenkins_public_ip" {
  value = aws_instance.jenkins[0].public_ip
}
```

Then expose it through environment outputs.

---

# Issue 6 – Terraform Output Shows Empty

Example:

```text
terraform output

Warning: No outputs found
```

Cause:

Outputs not defined in root module.

---

## Solution

Create:

```text
outputs.tf
```

Example:

```hcl
output "jenkins_public_ip" {
  value = module.ec2.jenkins_public_ip
}
```

Apply again:

```bash
terraform apply
```

---

# Issue 7 – Terraform State Lock

Example:

```text
Acquiring state lock...
```

or

```text
Error acquiring the state lock
```

Cause:

Another Terraform operation is running.

---

## Solution

Wait for current operation to finish.

If lock is stuck:

```bash
terraform force-unlock LOCK_ID
```

Use carefully.

---

# Issue 8 – AWS Credentials Not Found

Example:

```text
No valid credential sources found
```

Cause:

AWS CLI not configured.

---

## Solution

Configure AWS credentials.

```bash
aws configure
```

Provide:

```text
Access Key
Secret Key
Region
Output Format
```

Verify:

```bash
aws sts get-caller-identity
```

---

# Issue 9 – Permission Denied

Example:

```text
UnauthorizedOperation
```

Cause:

IAM user lacks permissions.

---

## Solution

Attach required policies.

Examples:

```text
AmazonEC2FullAccess
IAMFullAccess
AdministratorAccess
```

Use least privilege in production.

---

# Issue 10 – Duplicate Resource Names

Example:

```text
EntityAlreadyExists
```

Cause:

Resource already exists in AWS.

Example:

```text
IAM Role
Instance Profile
Security Group
```

---

## Solution

Option 1:

Import existing resource.

```bash
terraform import
```

Option 2:

Rename resource.

---

# Issue 11 – Terraform Init Errors

Example:

```text
Module not installed
```

or

```text
Provider not found
```

---

## Solution

Run:

```bash
terraform init
```

Again.

If providers changed:

```bash
terraform init -upgrade
```

---

# Issue 12 – Backend Configuration Changed

Example:

```text
Backend configuration changed
```

Cause:

Backend settings modified.

---

## Solution

Reinitialize backend.

```bash
terraform init -reconfigure
```

---

# Issue 13 – Invalid Variable Type

Example:

```text
Incorrect value type
```

Cause:

Wrong data type.

Example:

Expected:

```hcl
number
```

Provided:

```hcl
"3"
```

---

## Solution

Use correct types.

Example:

```hcl
node_count = 3
```

Not:

```hcl
node_count = "3"
```

---

# Issue 14 – EC2 Instance Not Created

Example:

```text
Plan shows no EC2 instances
```

Cause:

Feature toggle disabled.

Example:

```hcl
enable_jenkins = false
```

---

## Solution

Enable resource.

```hcl
enable_jenkins = true
```

Apply again.

---

# Issue 15 – Count Related Errors

Example:

```text
Invalid index
```

Cause:

Trying to access instance 0 when count = 0.

Example:

```hcl
aws_instance.jenkins[0]
```

but

```hcl
enable_jenkins = false
```

---

## Solution

Use conditional outputs.

Example:

```hcl
output "jenkins_public_ip" {
  value = var.enable_jenkins ? aws_instance.jenkins[0].public_ip : null
}
```

---

# Issue 16 – Public IP Not Showing

Example:

```text
terraform output public_ips
```

returns empty.

Cause:

Output missing.

---

## Solution

Create module outputs.

Example:

```hcl
output "public_ips" {
  value = {
    jenkins = aws_instance.jenkins[0].public_ip
  }
}
```

Apply again.

---

# Issue 17 – Wrong SSH User

Example:

```text
Permission denied (publickey)
```

Cause:

Wrong SSH username.

Ubuntu:

```bash
ssh -i key.pem ubuntu@IP
```

Amazon Linux:

```bash
ssh -i key.pem ec2-user@IP
```

---

# Issue 18 – Terraform Files Committed to GitHub

Problem:

Sensitive files accidentally committed.

Examples:

```text
terraform.tfstate
terraform.tfvars
.pem
```

---

## Solution

Use .gitignore

Example:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.pem
*.key
```

Remove tracked files:

```bash
git rm --cached FILE_NAME
```

---

# Issue 19 – Resource Drift

Example:

Engineer modifies AWS resource manually.

Terraform state:

```text
Old Configuration
```

AWS:

```text
New Configuration
```

---

## Solution

Detect differences.

```bash
terraform plan
```

Review and apply corrections.

---

# Issue 20 – Dependency Problems

Example:

```text
Resource not found
```

during creation.

Cause:

Terraform creating resources before dependencies exist.

---

## Solution

Use:

```hcl
depends_on = []
```

when necessary.

Example:

```hcl
depends_on = [
  aws_internet_gateway.igw
]
```

---

# RetailSphere Lessons Learned

During Phase 2, the most common issues encountered were:

```text
Variable Configuration Errors
CIDR Mistakes
Module Output Problems
Resource References
Terraform Output Errors
Feature Toggle Configuration
Git Ignore Configuration
State Management Issues
```

Resolving these problems improved understanding of:

```text
Terraform Modules
Outputs
State Management
AWS Infrastructure
Infrastructure as Code
```

---

# Summary

Terraform troubleshooting is an essential DevOps skill.

Most issues fall into one of the following categories:

```text
Variables
Modules
Outputs
State
Permissions
Dependencies
Networking
Git Management
```

By following a structured troubleshooting approach and understanding common error patterns, infrastructure issues can be identified and resolved quickly and safely.
