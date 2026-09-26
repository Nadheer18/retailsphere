variable "cluster_name" {

  description = "EKS cluster name"

  type = string
}


variable "kubernetes_version" {

  description = "Kubernetes version for EKS"

  type = string

  default = "1.36"
}


variable "environment" {

  description = "Environment name"

  type = string
}


variable "private_subnet_ids" {

  description = "Private subnet IDs for EKS"

  type = list(string)
}


variable "node_instance_type" {

  description = "EC2 instance type for EKS managed nodes"

  type = string

  default = "t3.medium"
}


variable "capacity_type" {

  description = "EKS node capacity type"

  type = string

  default = "ON_DEMAND"

  validation {

    condition = contains(
      ["ON_DEMAND", "SPOT"],
      var.capacity_type
    )

    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}


variable "desired_size" {

  description = "Desired number of EKS nodes"

  type = number

  default = 2
}


variable "min_size" {

  description = "Minimum number of EKS nodes"

  type = number

  default = 2
}


variable "max_size" {

  description = "Maximum number of EKS nodes"

  type = number

  default = 3
}