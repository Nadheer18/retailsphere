data "aws_ssm_parameter" "ubuntu" {

  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
 # This SSM parameter provides the latest Ubuntu 24.04 LTS AMI ID for the specified architecture and region.
}

resource "aws_instance" "kubeadm_master" {

  count = var.enable_kubeadm_master ? 1 : 0 # Assuming you have a variable for master count if needed
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.kubeadm_cluster_sg_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 30
  }
  tags = {
    Name = "retailsphere-kubeadm-master"
  }
}

resource "aws_instance" "kubeadm_worker" {

  count = var.enable_kubeadm_worker ? var.worker_count : 0 # Assuming you have a variable for worker count
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = "t3.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.kubeadm_cluster_sg_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 30
  }
  tags = {
    Name = "retailsphere-kubeadm-worker-${count.index + 1}"
  }
}