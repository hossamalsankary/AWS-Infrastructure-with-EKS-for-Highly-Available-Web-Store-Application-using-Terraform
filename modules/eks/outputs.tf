output "tls_certificate" {
    value = aws_eks_cluster.MyCluster.identity[0].oidc[0].issuer
  
}


output "cluster_endpoint" {
  value = aws_eks_cluster.MyCluster.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.MyCluster.certificate_authority[0].data
}

output "cluster_name" {
  value = aws_eks_cluster.MyCluster.name
}

output "cluster_arn" {
  value = aws_eks_cluster.MyCluster.arn
}