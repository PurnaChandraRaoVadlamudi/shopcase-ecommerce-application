# ===================================================================
# VPC Module - Production Grade with Multi-AZ Support
# ===================================================================

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name        = "${var.env}-vpc"
    Environment = var.env
    ManagedBy   = "terraform"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.env}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                       = "${var.env}-public-subnet-${count.index + 1}"
    Type                       = "public"
    Subnet                     = "public"
    "kubernetes.io/role"      = "ingress"
    "kubernetes.io/cluster"    = var.cluster_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name                = "${var.env}-private-subnet-${count.index + 1}"
    Type                = "private"
    Subnet              = "private"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Database Subnets (for Stateful Workloads)
resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.database_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name        = "${var.env}-database-subnet-${count.index + 1}"
    Type        = "database"
    Subnet      = "database"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.public_subnets)
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.env}-eip-${count.index + 1}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count = length(var.public_subnets)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id      = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    Name = "${var.env}-nat-${count.index + 1}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(var.tags, {
    Name = "${var.env}-private-rt-${count.index + 1}"
  })
}

# Database Route Table
resource "aws_route_table" "database" {
  count = length(var.database_subnets)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(var.tags, {
    Name = "${var.env}-database-rt-${count.index + 1}"
  })
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.env}-public-rt"
  })
}

# Route Table Associations - Public
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations - Private
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Route Table Associations - Database
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# Security Group: Cluster Control Plane
resource "aws_security_group" "cluster_control_plane" {
  name        = "${var.env}-cluster-control-plane-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Cluster API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env}-cluster-control-plane-sg"
  })
}

# Security Group: Node Group Security
resource "aws_security_group" "node_group" {
  name        = "${var.env}-node-group-sg"
  description = "Security group for EKS node groups"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Node to Node Communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Cluster API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env}-node-group-sg"
  })
}

# Security Group: Bastion Host
resource "aws_security_group" "bastion" {
  name        = "${var.env}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from Management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env}-bastion-sg"
  })
}