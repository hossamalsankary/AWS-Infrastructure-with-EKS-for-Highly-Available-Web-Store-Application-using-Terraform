

variable "launch_template_name_prefix" {
  description = "The name prefix to use for the launch template"
  type        = string
  default     = "launch_template"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the launch template"
  type        = string
  default     = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  description = "The instance type to use for the launch template"
  type        = string
  default     = "t3.medium"
}



variable "security_group_id" {
  description = "The ID of the security group to associate with the launch template"
  type        = string
}


variable "asg_name" {
  description = "The name to use for the autoscaling group"
  type        = string
  default     = "awsautoscalinggroup"
}

variable "desired_capacity" {
  description = "The desired number of instances for the autoscaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of instances for the autoscaling group"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "The minimum number of instances for the autoscaling group"
  type        = number
  default     = 1
}

variable "health_check_type" {
  description = "The type of health check to use for the autoscaling group"
  type        = string
  default     = "EC2"
}

variable "private_subnets" {
  description = "The IDs of the private subnets to associate with the autoscaling group"
  type        = list(string)
}

variable "jumb_server_ami_id" {
  description = "The ID of the AMI to use for the Jumb server EC2 instance"
  type        = string
  default     = "ami-07caf09b362be10b8"
}

variable "jumb_server_instance_type" {
  description = "The instance type to use for the Jumb server EC2 instance"
  type        = string
  default     = "t3.small"
}

variable "ec2_instance_profile" {
  description = "The IAM instance profile to associate with the Jumb server EC2 instance"
  type        = string
}

variable "jumb_server_subnet_id" {
  description = "The ID of the subnet to associate with the Jumb server EC2 instance"
  type        = string
}


variable "jumb_server_name" {
  description = "The name to assign to the Jumb server EC2 instance"
  type        = string
  default     = "jumb-server"
}
