variable "name" {
  type = string
  description = "VPC name"
}

variable "env" {
  type = string
  description = "Environment"
}

variable "cluster_version" {
  type = string
  description = "EKS cluster version"
  default = "1.24"
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnets"
}

variable "public_subnets" {
  type = list(string)
  description = "Public subnets"
}

variable "cluster_endpoint_private_access" {
  type = bool
  default = true
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = true
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  type = string
}

variable "vpc_owner_id" {
  type = string
}
