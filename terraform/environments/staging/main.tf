# =========================================================
# RETAILSPHERE STAGING VPC
# =========================================================

module "vpc" {

  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

  enable_nat_gateway = true
}


# =========================================================
# RETAILSPHERE STAGING EKS
# =========================================================

module "eks" {

  source = "../../modules/eks"

  cluster_name = var.eks_cluster_name

  kubernetes_version = var.kubernetes_version

  environment = var.environment

  private_subnet_ids = [

    module.vpc.private_subnet_a_id,
    module.vpc.private_subnet_b_id

  ]

  node_instance_type = var.eks_node_instance_type

  capacity_type = var.eks_capacity_type

  desired_size = var.eks_desired_nodes

  min_size = var.eks_min_nodes

  max_size = var.eks_max_nodes
}