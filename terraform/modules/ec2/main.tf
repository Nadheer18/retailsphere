data "aws_ssm_parameter" "ubuntu" {

  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"

}

resource "aws_instance" "bastion" {

  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "retailsphere-bastion"
  }
}

resource "aws_instance" "jenkins" {

  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.jenkins_instance_profile

  tags = {
    Name = "retailsphere-jenkins"
  }
}

resource "aws_instance" "infra" {

  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.infra_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.infra_instance_profile

  tags = {
    Name = "retailsphere-infra"
  }
}

resource "aws_instance" "developer" {

  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.developer_sg_id]
  key_name               = var.key_name

  iam_instance_profile = var.developer_instance_profile

  tags = {
    Name = "retailsphere-developer"
  }
}