
# create eks cluster
resource "aws_eks_cluster" "MyCluster" {
  name     = var.cluster_name
  role_arn = var.eks_iam_role_arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    endpoint_private_access = var.endpoint_public_access ? false : true
    endpoint_public_access  =  var.endpoint_public_access ? true : false
    security_group_ids = [ var.eks_security_group_id ]
    subnet_ids = var.subnet_ids
  }

}

# create node group
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.MyCluster.name
  node_group_name = "${var.cluster_name}-private-nodes"
  node_role_arn   = var.eks_nodes_iam_role_arn

  subnet_ids = var.nodes_subnet_ids

  capacity_type  = var.capacity_type
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }


  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

}

resource "aws_launch_template" "eks-with-disks" {
  name = "${var.cluster_name}-eks-with-disks"

  key_name = "local-provisioner"

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }
}



