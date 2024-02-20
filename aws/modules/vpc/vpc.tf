data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  nat =  length(var.subnets_internal) > 0 ? 1 : 0
}
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = "vpc-${var.name}"
    env = "${var.env}"
    project = "${var.project}"
    role = "vpc"
  }
}
#### k8s network
resource "aws_vpc_ipv4_cidr_block_association" "k8s_cidr" {
  count = var.k8s_network_enable ? 1 : 0
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.k8s_vpc_cidr_block
}
resource "aws_subnet" "k8s_internal" {
  count         = var.k8s_network_enable ? length(var.k8s_subnets_internal) : 0
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.k8s_subnets_internal[count.index].ip_cidr_range
  map_public_ip_on_launch = false

  tags = {
    Name = "k8s_subnet-${var.name}-${count.index + 1}"
    env = "${var.env}"
    subnet = "k8s"
    role = "subnet"
    "kubernetes.io/role/internal-elb" = "1"
  }
  depends_on = [aws_vpc.vpc_main, aws_vpc_ipv4_cidr_block_association.k8s_cidr]
}
resource "aws_route_table" "k8s_route_table" {
  count         = var.k8s_network_enable ? 1 : 0
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }

  tags = {
    Name = "route_${var.name}_k8s"
    env = "${var.env}"
    role = "route"
  }
  depends_on   = [aws_nat_gateway.nat_gw,aws_subnet.k8s_internal]
}
resource "aws_route_table_association" "k8s_route_match" {
  count         = var.k8s_network_enable ? length(var.k8s_subnets_internal) : 0
  subnet_id      = aws_subnet.k8s_internal[count.index].id
  route_table_id = aws_route_table.k8s_route_table[0].id
  depends_on = [aws_route_table.k8s_route_table]
}

## k8s network

resource "aws_subnet" "main_public" {
  count         = length(var.subnets_public)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.subnets_public[count.index].ip_cidr_range
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet-${var.name}-${count.index + 1}"
    env = "${var.env}"
    subnet = "public"
    role = "subnet"
  }
}
resource "aws_subnet" "main_internal" {
  count         = length(var.subnets_internal)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.subnets_internal[count.index].ip_cidr_range

  tags = {
    Name = "internal_subnet-${var.name}-${count.index + 1}"
    env = "${var.env}"
    subnet = "internal"
    role = "subnet"
  }
}
resource "aws_subnet" "main_private" {
  count         = length(var.subnets_private)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.subnets_private[count.index].ip_cidr_range

  tags = {
    Name = "private_subnet-${var.name}-${count.index + 1}"
    env = "${var.env}"
    subnet = "private"
    role = "subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-${var.name}"
    env = "${var.env}"
    role = "igw"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-public-${var.name}"
    env = "${var.env}"
    role = "route"
  }
}
resource "aws_route_table_association" "public_route_match" {
  count         = length(var.subnets_public)
  subnet_id      = aws_subnet.main_public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table" "internal_route_table" {
  count         = local.nat
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }

  tags = {
    Name = "route-internal-${var.name}"
    env = "${var.env}"
    role = "route"
  }
  depends_on                = [aws_nat_gateway.nat_gw]
}
resource "aws_route_table_association" "internal_route_match" {
  count         = length(var.subnets_internal)
  subnet_id      = aws_subnet.main_internal[count.index].id
  route_table_id = aws_route_table.internal_route_table[0].id
  depends_on = [aws_route_table.internal_route_table]
}
resource "aws_nat_gateway" "nat_gw" {
  count         = local.nat
  depends_on = [aws_subnet.main_internal]
  allocation_id = aws_eip.public_ip[count.index].id
  subnet_id     = aws_subnet.main_public[0].id
  tags = {
    Name = "nat-${var.name}-${count.index + 1}"
    env = "${var.env}"
    role = "nat"
  }
}

resource "aws_eip" "public_ip" {
  count         = local.nat
  domain = "vpc"
  tags = {
    Name = "nat-eip-${var.name}-${count.index + 1}"
    env = "${var.env}"
    role = "nat"
  }
}