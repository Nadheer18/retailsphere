# =========================================================
# AWS
# =========================================================

variable "aws_region" {

  description = "AWS region for the staging environment"

  type = string
}


# =========================================================
# ENVIRONMENT
# =========================================================

variable "environment" {

  description = "Environment name"

  type = string
}


# =========================================================
# VPC
# =========================================================

variable "vpc_cidr" {

  description = "Staging VPC CIDR"

  type = string
}


variable "public_subnet_1_cidr" {

  description = "Staging public subnet A CIDR"

  type = string
}


variable "public_subnet_2_cidr" {

  description = "Staging public subnet B CIDR"

  type = string
}


variable "private_subnet_1_cidr" {

  description = "Staging private subnet A CIDR"

  type = string
}


variable "private_subnet_2_cidr" {

  description = "Staging private subnet B CIDR"

  type = string
}


# =========================================================
# EKS
# =========================================================

variable "eks_cluster_name" {

  description = "EKS cluster name"

  type = string
}


variable "kubernetes_version" {

  description = "Kubernetes version for EKS"

  type = string

  default = "1.36"
}


variable "eks_node_instance_type" {

  description = "EC2 instance type for EKS nodes"

  type = string

  default = "t3.medium"
}


variable "eks_capacity_type" {

  description = "EKS node capacity type"

  type = string

  default = "ON_DEMAND"

  validation {

    condition = contains(
      ["ON_DEMAND", "SPOT"],
      var.eks_capacity_type
    )

    error_message = "eks_capacity_type must be ON_DEMAND or SPOT."
  }
}


variable "eks_desired_nodes" {

  description = "Desired number of EKS nodes"

  type = number

  default = 2
}


variable "eks_min_nodes" {

  description = "Minimum number of EKS nodes"

  type = number

  default = 2
}


variable "eks_max_nodes" {

  description = "Maximum number of EKS nodes"

  type = number

  default = 3
}