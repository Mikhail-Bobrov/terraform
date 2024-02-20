resource "aws_vpc" "vpc-main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = "vpc-${var.name}"
    environment = "${var.name}"
  }
}
resource "aws_subnet" "main-public" {
  count         = length(var.subnets_public)
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = var.subnets_public[count.index].ip_cidr_range
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet-${var.name}-${count.index + 1}"
    environment = "${var.name}"
    subnet = "public"
  }
}
resource "aws_subnet" "main-internal" {
  count         = length(var.subnets_internal)
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = var.subnets_internal[count.index].ip_cidr_range

  tags = {
    Name = "internal_subnet-${var.name}-${count.index + 1}"
    environment = "${var.name}"
    subnet = "internal"
  }
}
resource "aws_subnet" "main-private" {
  count         = length(var.subnets_private)
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = var.subnets_private[count.index].ip_cidr_range

  tags = {
    Name = "private_subnet-${var.name}-${count.index + 1}"
    environment = "${var.name}"
    subnet = "private"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "igw-${var.name}"
    environment = "${var.name}"
  }
}
# resource "aws_internet_gateway_attachment" "igw_match" {
#   internet_gateway_id = aws_internet_gateway.igw.id
#   vpc_id              = aws_vpc.vpc-main.id
# }
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-public-${var.name}"
    environment = "${var.name}"
  }
}
resource "aws_route_table_association" "public_route_match" {
  count         = length(var.subnets_public)
  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table" "internal_route_table" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }

  tags = {
    Name = "route-internal-${var.name}"
    environment = "${var.name}"
  }
  depends_on                = [aws_nat_gateway.nat_gw]
}
resource "aws_route_table_association" "internal_route_match" {
  count         = length(var.subnets_internal)
  subnet_id      = aws_subnet.main-internal[count.index].id
  route_table_id = aws_route_table.internal_route_table.id
  depends_on = [aws_route_table.internal_route_table]
}
resource "aws_nat_gateway" "nat_gw" {
  count         = var.nat_count > 0 && length(aws_subnet.main-internal) > 0 ? var.nat_count : 0
  depends_on = [aws_subnet.main-internal]
  allocation_id = aws_eip.public_ip[count.index].id
  subnet_id     = aws_subnet.main-internal[count.index].id
}
resource "aws_eip" "public_ip" {
  count         = var.nat_count > 0 && length(aws_subnet.main-internal) > 0 ? var.nat_count : 0
  domain = "vpc"
  depends_on                = [aws_subnet.main-internal]
}