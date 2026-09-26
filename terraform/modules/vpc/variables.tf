variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet B"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = false
}