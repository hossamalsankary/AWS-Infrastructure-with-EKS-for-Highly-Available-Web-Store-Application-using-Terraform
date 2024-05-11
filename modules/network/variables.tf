variable "vpc_name" {
  type = string
  default = "eks-vpc"
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "vpc_cidr_block" {
   type = string
   default = "10.0.0.0/16"
}


variable "public_subnet_count" {
  type = number
  default = 2
}
variable "private_subnet_count" {
  type = number
  default = 2
}

variable "endpoint_public_access" {
  type = bool
  default = true
}