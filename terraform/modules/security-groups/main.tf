resource "aws_security_group" "jenkins" {

  name        = "retailsphere-jenkins-sg"
  description = "Jenkins Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-jenkins-sg"
  }
}
##Jenkins Security Group allows SSH, Jenkins, and SonarQube access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.

resource "aws_security_group" "infra" {

  name        = "retailsphere-infra-sg"
  description = "Infrastructure Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-infra-sg"
  }
}
##Infrastructure Security Group allows SSH access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.

resource "aws_security_group" "developer" {

  name        = "retailsphere-developer-sg"
  description = "Developer Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-developer-sg"
  }
}
##Developer Security Group allows SSH access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.

resource "aws_security_group" "bastion" {

  name        = "retailsphere-bastion-sg"
  description = "Bastion Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.57.28.14/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-bastion-sg"
  }
}
##Bastion Security Group allows SSH access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.

resource "aws_security_group" "kubeadm_cluster" {

  name        = "retailsphere-kubeadm-cluster-sg"
  description = "Kubeadm Cluster Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubelet"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flannel VXLAN"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-kubeadm-cluster-sg"
  }
}
##Kubeadm Cluster Security Group allows SSH, Kubernetes API, Kubelet, NodePort, Flannel VXLAN, HTTP, and HTTPS access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.

resource "aws_security_group" "eks_cluster" {

  name        = "retailsphere-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retailsphere-eks-cluster-sg"
  }
}
##EKS Cluster Security Group allows HTTPS and Kubelet access from anywhere, which is not recommended for production environments. Consider restricting the CIDR blocks to specific IP addresses or ranges for enhanced security.