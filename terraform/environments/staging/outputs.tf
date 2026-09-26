# =========================================================
# VPC OUTPUTS
# =========================================================

output "vpc_id" {

  description = "Staging VPC ID"

  value = module.vpc.vpc_id
}


output "vpc_cidr" {

  description = "Staging VPC CIDR"

  value = module.vpc.vpc_cidr
}


output "public_subnet_a_id" {

  description = "Staging public subnet A"

  value = module.vpc.public_subnet_a_id
}


output "public_subnet_b_id" {

  description = "Staging public subnet B"

  value = module.vpc.public_subnet_b_id
}


output "private_subnet_a_id" {

  description = "Staging private subnet A"

  value = module.vpc.private_subnet_a_id
}


output "private_subnet_b_id" {

  description = "Staging private subnet B"

  value = module.vpc.private_subnet_b_id
}


output "nat_gateway_id" {

  description = "Staging NAT Gateway"

  value = module.vpc.nat_gateway_id
}


# =========================================================
# EKS OUTPUTS
# =========================================================

output "eks_cluster_name" {

  description = "EKS cluster name"

  value = module.eks.cluster_name
}


output "eks_cluster_arn" {

  description = "EKS cluster ARN"

  value = module.eks.cluster_arn
}


output "eks_cluster_endpoint" {

  description = "EKS cluster API endpoint"

  value = module.eks.cluster_endpoint
}


output "eks_cluster_version" {

  description = "EKS Kubernetes version"

  value = module.eks.cluster_version
}


output "eks_cluster_security_group_id" {

  description = "EKS cluster security group ID"

  value = module.eks.cluster_security_group_id
}


output "eks_cluster_iam_role_arn" {

  description = "EKS cluster IAM role ARN"

  value = module.eks.cluster_iam_role_arn
}


output "eks_node_iam_role_arn" {

  description = "EKS node IAM role ARN"

  value = module.eks.node_iam_role_arn
}


output "eks_node_group_name" {

  description = "EKS managed node group name"

  value = module.eks.node_group_name
}