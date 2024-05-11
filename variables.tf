variable "bucket_name" {
    type = string
    default = "statefilebuckernamedata"
    description = "name of the bucket"
  
}
variable "cluster_name" {
  type = string
  default = "MyCluster"
}


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

variable "user_data_file" {
  description = "The path to the file containing the user data script"
  type        = string
  default     = "setupAgent.sh"
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


variable "jumb_server_instance_type" {
  description = "The instance type for the Jump Server"
  type        = string
  default     = "t3.medium"
}

