resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "project-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_eks" {
  count                   = length(var.private_eks_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_eks_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-eks-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "monitoring" {
  count                   = length(var.monitoring_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.monitoring_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "monitoring-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = 2

  # vpc = true
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "eks_az1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "eks-rt-az1"
  }
}

resource "aws_route_table_association" "eks_az1_assoc" {
  subnet_id      = aws_subnet.private_eks[0].id
  route_table_id = aws_route_table.eks_az1.id
}

resource "aws_route_table" "eks_az2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[1].id
  }

  tags = {
    Name = "eks-rt-az2"
  }
}

resource "aws_route_table_association" "eks_az2_assoc" {
  subnet_id      = aws_subnet.private_eks[1].id
  route_table_id = aws_route_table.eks_az2.id
}

# resource "aws_route_table" "monitoring" {
#   vpc_id = aws_vpc.main.id

  # # Pick NAT gateway 1 here. Change to nat[1] if you want the other NAT.
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat[0].id
  # }

#   tags = {
#     Name = "monitoring-rt"
#   }
# }

# resource "aws_route_table_association" "monitoring_assoc" {
#   count          = length(var.monitoring_subnet_cidrs)
#   subnet_id      = aws_subnet.monitoring[count.index].id
#   route_table_id = aws_route_table.monitoring.id
# }