data "aws_ssm_parameter" "ubuntu" {

  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
 # This SSM parameter provides the latest Ubuntu 24.04 LTS AMI ID for the specified architecture and region.
}

resource "aws_instance" "bastion" { 

  count = var.enable_bastion ? 1 : 0
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "retailsphere-bastion"
  }
}

resource "aws_instance" "jenkins" {

  count = var.enable_jenkins ? 1 : 0
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro" #t3.medium
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.jenkins_instance_profile

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "retailsphere-jenkins"
  }
}

resource "aws_instance" "infra" {

  count = var.enable_infra ? 1 : 0
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.infra_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.infra_instance_profile

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "retailsphere-infra"
  }
  user_data = file("${path.module}/scripts/infra-server.sh") # This script will run on instance launch to set up the infra server.
}

resource "aws_instance" "developer" {

  count = var.enable_developer ? var.developer_count : 0 # Assuming you have a variable for developer count
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.developer_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.developer_instance_profile

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "retailsphere-developer-${count.index + 1}"
  }
}
