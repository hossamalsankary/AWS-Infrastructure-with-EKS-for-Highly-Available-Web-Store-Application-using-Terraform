variable "cluster_name" {
  type = string
  default = "MyCluster"
}


variable "eks_iam_role_arn" {
  type = string
}


variable "eks_nodes_iam_role_arn" {
  type = string
}


variable "subnet_ids" {
  type = list(string)
}

variable "nodes_subnet_ids" {
  type = list(string)
}


variable "capacity_type" {
  type = string
  default = "ON_DEMAND"
}
variable "instance_types" {
  type = list(string)
  default = ["t3.small"]
}


variable "desired_size" {
  type = number
  default = 2
}
variable "max_size" {
  type = number
  default = 5
}
variable "min_size" {
  type = number
  default = 1
}
variable "endpoint_public_access" {
  type = bool
  default = true
}

variable "eks_security_group_id" {
  type = string
  
}