output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}

output "private_subnet_id" {
  value = aws_subnet.private.*.id
}   

output "availability_zone" {
  value = data.aws_availability_zones.available.names
}



output "internet_gateway" {
  value = aws_internet_gateway.igw-eks.id
}

output "vpc_cidrs" {
  value = aws_vpc.eks_vpc.cidr_block
}


output "security_group" {
  value = aws_security_group.security_group.id
}

output "eks_security_group_allow_443" {
  value = aws_security_group.eks_security_group_allow_443.id
  
}