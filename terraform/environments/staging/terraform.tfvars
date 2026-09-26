# =========================================================
# AWS
# =========================================================

aws_region = "ap-south-1"


# =========================================================
# ENVIRONMENT
# =========================================================

environment = "staging"


# =========================================================
# VPC
# =========================================================

vpc_cidr = "10.1.0.0/16"

public_subnet_1_cidr = "10.1.1.0/24"

public_subnet_2_cidr = "10.1.2.0/24"

private_subnet_1_cidr = "10.1.11.0/24"

private_subnet_2_cidr = "10.1.12.0/24"


# =========================================================
# EKS
# =========================================================

eks_cluster_name = "retailsphere-staging"

kubernetes_version = "1.36"

eks_node_instance_type = "t3.medium"

eks_capacity_type = "ON_DEMAND"

eks_desired_nodes = 2

eks_min_nodes = 2

eks_max_nodes = 3