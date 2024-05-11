# Configure the required AWS provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # Configure the S3 backend for storing Terraform state
  # Uncomment the following lines and replace the values with your own to use the S3 backend
  # backend "s3" {
  #   bucket  = "statefilebuckernamedata"
  #   key     = "terraform.tfstate"
  #   region  = "us-east-1"
  # }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Set the AWS region
}

# Define the local variables
locals {
  # Define the network variables
  network = {
    vpc_name             = "${var.cluster_name}-vpc" # Define the VPC name
    region               = "us-east-1"               # Define the AWS region
    public_subnet_count  = 2                         # Define the number of public subnets
    private_subnet_count = 2                        # Define the number of private subnets
    vpc_cidr_block       = "10.0.0.0/16"             # Define the CIDR block for the VPC
  }
}

# Create the network module
module "network" {
  source               = "./modules/network"  # Define the source of the module
  vpc_name             = local.network.vpc_name
  region               = local.network.region
  public_subnet_count  = local.network.public_subnet_count
  private_subnet_count = local.network.private_subnet_count
  vpc_cidr_block       = local.network.vpc_cidr_block
}

# Create the IAM roles module
module "Iam" {
  source = "./modules/iam_roles" # Define the source of the module
}

# Create the EKS cluster module
module "eks" {
  source = "./modules/eks" # Define the source of the module

  # Define the EKS cluster variables
  cluster_name           = "MyCluster"
  endpoint_public_access = true
  eks_iam_role_arn       = module.Iam.eks_iam_role.arn
  eks_nodes_iam_role_arn = module.Iam.eks_nodes_iam_role.arn
  eks_security_group_id  = module.network.eks_security_group_allow_443
  subnet_ids             = module.network.public_subnet_id
  nodes_subnet_ids       = module.network.private_subnet_id
  depends_on             = [module.Iam]
}

# Create the OpenID Connector module
module "openid-connector" {
  depends_on          = [module.eks]
  source              = "./modules/openid-connector"
  tls_certificate_eks = module.eks.tls_certificate
}

# Create the Kubernetes (k8s) module
module "k8s" {
  source                        = "./modules/k8s"
  cluster_endpoint              = module.eks.cluster_endpoint
  cluster_certificate_authority = module.eks.cluster_certificate_authority_data
  cluster_name                  = module.eks.cluster_name
  cluster_arn                   = module.eks.cluster_arn
}

# Create the Build Agent module
module "buildagent" {
  source = "./modules/build-agent"

  # Define the launch template variables
  ami_id        = var.ami_id
  instance_type = var.instance_type

  # Define the autoscaling group variables
  asg_name          = "${var.cluster_name}-autoscaling-group"
  private_subnets   = module.network.private_subnet_id
  desired_capacity  = var.desired_capacity
  max_size          = var.max_size
  min_size          = var.min_size
  health_check_type = var.health_check_type

  # Define the Jenkins Jumb Server variables
  jumb_server_name          = "${var.cluster_name}-jumb-server"
  jumb_server_instance_type = var.jumb_server_instance_type
  jumb_server_subnet_id     = module.network.public_subnet_id[0]
  ec2_instance_profile      = module.Iam.ec2_instance_profile
  security_group_id         = module.network.security_group
}

