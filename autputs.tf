
output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "test_policy_arn" {
  value = module.openid-connector.test_policy_arn
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}