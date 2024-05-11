output "eks_iam_role" {
  value = aws_iam_role.eks_iam_role
}

output "eks_nodes_iam_role" {
  value = aws_iam_role.eks-node_iam_role
}


output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

