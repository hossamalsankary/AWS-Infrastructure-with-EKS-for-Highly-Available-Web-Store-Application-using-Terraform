# IAM role for EKS
resource "aws_iam_role" "eks_iam_role" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# IAM role for nodes
resource "aws_iam_role" "eks-node_iam_role" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}



# attach policies
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  count = length(var.eks_policys)
  policy_arn = var.eks_policys[count.index]
  role       = aws_iam_role.eks_iam_role.name
}

# attach nodes policies
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count = length(var.eks_nodes_policys)
  policy_arn = var.eks_nodes_policys[count.index]
  role       = aws_iam_role.eks-node_iam_role.name
}

# allow EKS describe cluster
resource "aws_iam_policy" "eks_describe_cluster_policy" {
  name        = "eks_describe_cluster_policy"
  description = "Policy to allow EKS cluster describe"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:ListTagsForResource"
      ],
      Resource = "*"
    }]
  })
}



# allow Jumb server to call EKS without credentials
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.eks_ec2_role.name
}

resource "aws_iam_role" "eks_ec2_role" {
  name               = "eks-ec2-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_ec2_role_attachment" {
  role       = aws_iam_role.eks_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_describe_cluster_policy_attachment" {
  policy_arn = aws_iam_policy.eks_describe_cluster_policy.arn
  role       = aws_iam_role.eks_ec2_role.name
}


