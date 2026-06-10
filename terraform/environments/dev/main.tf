module "vpc" {

  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

module "security_groups" {

  source = "../../modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"
}

module "ec2" {

  source = "../../modules/ec2"

  public_subnet_id = module.vpc.public_subnet_1_id

  jenkins_sg_id   = module.security_groups.jenkins_sg_id
  infra_sg_id     = module.security_groups.infra_sg_id
  developer_sg_id = module.security_groups.developer_sg_id
  bastion_sg_id   = module.security_groups.bastion_sg_id

  jenkins_instance_profile   = module.iam.jenkins_instance_profile
  infra_instance_profile     = module.iam.infra_instance_profile
  developer_instance_profile = module.iam.developer_instance_profile

  key_name = "mumbai-region"
}