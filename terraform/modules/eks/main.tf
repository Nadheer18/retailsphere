data "aws_iam_policy_document" "eks_cluster_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "eks.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "eks_node_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


# ---------------------------------------------------------
# EKS CLUSTER IAM ROLE
# ---------------------------------------------------------

resource "aws_iam_role" "eks_cluster" {

  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name        = "${var.cluster_name}-cluster-role"
    Environment = var.environment
    Project     = "RetailSphere"
  }
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# ---------------------------------------------------------
# EKS NODE IAM ROLE
# ---------------------------------------------------------

resource "aws_iam_role" "eks_node" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = {
    Name        = "${var.cluster_name}-node-role"
    Environment = var.environment
    Project     = "RetailSphere"
  }
}


resource "aws_iam_role_policy_attachment" "eks_worker" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "eks_ecr" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_role_policy_attachment" "eks_cni" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


# ---------------------------------------------------------
# EKS CLUSTER
# ---------------------------------------------------------

resource "aws_eks_cluster" "this" {

  name = var.cluster_name

  role_arn = aws_iam_role.eks_cluster.arn

  version = var.kubernetes_version

  vpc_config {

    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true

    endpoint_public_access = true
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    Project     = "RetailSphere"
  }

  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]
}


# ---------------------------------------------------------
# EKS MANAGED NODE GROUP
# ---------------------------------------------------------

resource "aws_eks_node_group" "this" {

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.cluster_name}-nodes"

  node_role_arn = aws_iam_role.eks_node.arn

  subnet_ids = var.private_subnet_ids

  instance_types = [
    var.node_instance_type
  ]

  capacity_type = var.capacity_type

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size
  }

  update_config {

    max_unavailable = 1
  }

  tags = {
    Name        = "${var.cluster_name}-nodes"
    Environment = var.environment
    Project     = "RetailSphere"
  }

  depends_on = [

    aws_iam_role_policy_attachment.eks_worker,
    aws_iam_role_policy_attachment.eks_ecr,
    aws_iam_role_policy_attachment.eks_cni

  ]
}