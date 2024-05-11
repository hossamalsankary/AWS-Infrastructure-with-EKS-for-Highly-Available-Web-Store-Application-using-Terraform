# This file creates a VPC with public and private subnets

locals {
  # Define the route for the internet gateway
  cidr_block_route = "0.0.0.0/0"
  
}

# Create VPC
resource "aws_vpc" "eks_vpc" {
  # Define the CIDR block for the VPC
  cidr_block = var.vpc_cidr_block
  
  # Define the tag for the VPC
  tags = {
    Name = var.vpc_name
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw-eks" {
  # Associate the internet gateway with the VPC
  vpc_id = aws_vpc.eks_vpc.id
  
  # Define the tag for the internet gateway
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

# Get the available availability zones
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  # Define the tag for the public subnet
  tags = {
    "Name"                       = "${var.vpc_name}_public_sub${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/role/elb"     = "1"

  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.eks_vpc.id
  depends_on = [ aws_internet_gateway.igw-eks ]
  route {
    cidr_block = local.cidr_block_route
    gateway_id = aws_internet_gateway.igw-eks.id
  }
  tags = {
    Name = "public_route_table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public-route_table_association" {
  count = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}

# Create private subnets
resource "aws_subnet" "private" {
  count = var.private_subnet_count
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(data.aws_availability_zones.available.names , count.index)
  
  tags = {
    "Name"                            = "${var.vpc_name}_private-sub${count.index}-${element(data.aws_availability_zones.available.names , count.index)}"
    "kubernetes.io/role/internal-elb" = "1" 
    
  }
}

# Create a subnet for the build agents
resource "aws_subnet" "Privet-Buildagent-Subnet" {
  count = 2
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 5 )
  availability_zone = element(data.aws_availability_zones.available.names , count.index)
  map_public_ip_on_launch = true  
  tags = {
    "Name"                            = "${var.vpc_name}-Build-Agent-Privet-subnet${count.index}"    
  }
}

# Create elastic IPs for the NAT gateways
resource "aws_eip" "nat" {
  count = var.public_subnet_count
  tags = {
    Name = "nat-eks-elasticip${count.index}"
  }
}
 
# Create NAT gateways
resource "aws_nat_gateway" "nat-eks" {
  count = var.public_subnet_count
  depends_on = [ aws_subnet.public ] 
  allocation_id = aws_eip.nat[count.index].id

  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = count.index == 1 ? "${var.vpc_name}-netgateway-1" : "${var.vpc_name}-build-agent-netgateway-2"
  }
}

# Create route tables for the private subnets
resource "aws_route_table" "Private_route_table" {
  count = var.private_subnet_count
  depends_on = [ aws_nat_gateway.nat-eks ]
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = local.cidr_block_route
    gateway_id = aws_nat_gateway.nat-eks[count.index].id
  }
  tags = {
    Name = "${var.vpc_name}-Private_route_table-${count.index}"
  }
}

# Associate the route tables with the private subnets
resource "aws_route_table_association" "private-route_table_association" {
  count = var.public_subnet_count
  depends_on = [  aws_route_table.Private_route_table ]
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.Private_route_table[count.index].id
}


# Create a security group for the EKS cluster
resource "aws_security_group" "security_group" {
  name        = "Jumb-server-sg"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


  # Create a security group for the EKS cluster to allow 443 inbound traffic
resource "aws_security_group" "eks_security_group_allow_443" {
  name        = "allow_443"
  description = "Allow 443 inbound traffic"
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_443"

  }
}