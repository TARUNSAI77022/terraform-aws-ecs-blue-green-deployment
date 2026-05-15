# Define local variables for consistent naming conventions
locals {
  name_prefix = var.project_name
}

# Fetch available Availability Zones in the region to distribute subnets
# This ensures High Availability (HA) by allowing us to span multiple AZs.
data "aws_availability_zones" "available" {
  state = "available"
}

# ------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------
# Create the primary Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc-main"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------------------------
# The Internet Gateway allows instances in public subnets to access the internet.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.environment}-internet-gateway-igw"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# Public Subnets
# ------------------------------------------------------------------------------
# Public subnets route traffic to the Internet Gateway. 
# Instances here can have public IPs and are reachable from the internet.
# Spread across multiple AZs for High Availability.
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true # Auto-assign public IP
  tags = {
    Name        = "${var.project_name}-${var.environment}-subnet-public"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# Private Subnets
# ------------------------------------------------------------------------------
# Private subnets do not have direct internet access.
# They route external traffic through the NAT Gateway.
# Spread across multiple AZs for High Availability.
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # map_public_ip_on_launch defaults to false
  tags = {
    Name        = "${var.project_name}-${var.environment}-subnet-private"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# NAT Gateway and Elastic IP
# ------------------------------------------------------------------------------
# Allocate an Elastic IP for the NAT Gateway
# resource "aws_eip" "nat" {
#   domain = "vpc"

#   tags = {
#     Name = "${local.name_prefix}-nat-eip"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# The NAT Gateway allows instances in private subnets to initiate outbound 
# traffic to the internet (e.g., for updates) while preventing inbound traffic.
# Currently deployed as a Single NAT Gateway in the first public subnet 
# to optimize costs. (Note: This is a single point of failure).
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "${local.name_prefix}-nat"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# --- Optional Multi-NAT Gateway setup for full High Availability ---
# Uncomment the following block (and comment out the single NAT setup above)
# to provision one NAT Gateway per Availability Zone.
#
# resource "aws_eip" "nat" {
#   count  = length(var.public_subnet_cidrs)
#   domain = "vpc"
#   tags = {
#     Name = "${local.name_prefix}-nat-eip-${count.index + 1}"
#   }
#   depends_on = [aws_internet_gateway.igw]
# }
#
# resource "aws_nat_gateway" "nat" {
#   count         = length(var.public_subnet_cidrs)
#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id
#   tags = {
#     Name = "${local.name_prefix}-nat-${count.index + 1}"
#   }
#   depends_on = [aws_internet_gateway.igw]
# }

# ------------------------------------------------------------------------------
# Route Tables
# ------------------------------------------------------------------------------
# Public Route Table: Routes 0.0.0.0/0 (all external traffic) to the IGW.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "${var.project_name}-${var.environment}-route-table-public"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Private Route Table: Routes 0.0.0.0/0 to the NAT Gateway.
# Note: For Multi-NAT setup, you would need one private route table per AZ.
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "${local.name_prefix}-private-rt"
#   }
# }

# ------------------------------------------------------------------------------
# Route Table Associations
# ------------------------------------------------------------------------------
# Note: AWS Route Table Associations do not support tags.

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Table
# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }
