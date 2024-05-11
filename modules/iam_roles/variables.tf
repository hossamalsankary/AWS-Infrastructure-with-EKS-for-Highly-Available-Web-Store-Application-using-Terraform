variable "eks_nodes_policys" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
     "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      ]
}


variable "eks_policys" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

      ]
}
