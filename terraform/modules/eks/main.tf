# =========================================================
# DATA SOURCES
# =========================================================

data "tls_certificate" "eks_oidc" {

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}


# =========================================================
# EKS CLUSTER IAM ROLE
# =========================================================

data "aws_iam_policy_document" "eks_cluster_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "eks.amazonaws.com"
      ]
    }
  }
}


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


# =========================================================
# EKS NODE IAM ROLE
# =========================================================

data "aws_iam_policy_document" "eks_node_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


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


# =========================================================
# EKS CLUSTER
# =========================================================

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


# =========================================================
# EKS MANAGED NODE GROUP
# =========================================================

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


# =========================================================
# EKS OIDC PROVIDER
# =========================================================

resource "aws_iam_openid_connect_provider" "eks" {

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name        = "${var.cluster_name}-oidc"
    Environment = var.environment
    Project     = "RetailSphere"
  }
}


# =========================================================
# EBS CSI DRIVER IAM TRUST POLICY
# =========================================================

data "aws_iam_policy_document" "ebs_csi_assume_role" {

  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    effect = "Allow"

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(
        aws_eks_cluster.this.identity[0].oidc[0].issuer,
        "https://",
        ""
      )}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(
        aws_eks_cluster.this.identity[0].oidc[0].issuer,
        "https://",
        ""
      )}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}


# =========================================================
# EBS CSI DRIVER IAM ROLE
# =========================================================

resource "aws_iam_role" "ebs_csi" {

  name = "${var.cluster_name}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = {
    Name        = "${var.cluster_name}-ebs-csi-role"
    Environment = var.environment
    Project     = "RetailSphere"
  }
}


# =========================================================
# EBS CSI DRIVER IAM POLICY
# =========================================================

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


# =========================================================
# EBS CSI DRIVER EKS MANAGED ADD-ON
# =========================================================

resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name        = "${var.cluster_name}-ebs-csi"
    Environment = var.environment
    Project     = "RetailSphere"
  }

  depends_on = [

    aws_iam_role_policy_attachment.ebs_csi,
    aws_eks_node_group.this

  ]
}