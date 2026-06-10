variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}