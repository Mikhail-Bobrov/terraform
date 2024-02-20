data "aws_vpc" "vpc_data" {
    filter {
      name   = "tag:env"
      values = ["${var.env}"]
  }
    filter {
      name   = "tag:Name"
      values = ["*${var.name}*"]
  }
}
resource "aws_security_group" "main_security_group_custom" {
  name   = "sg_${var.name}_custom"
  vpc_id = data.aws_vpc.vpc_data.id
  description = var.sg_allow_ssh ? "opened port  ${var.sg_ssh_custom_port}, ${join(", ", var.sg_ingress)}" : "opened port ${join(", ", var.sg_ingress)}"

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "ingress" {
    for_each = var.sg_allow_ssh ? [1] : []
    content {
      from_port   = var.sg_ssh_custom_port
      to_port     = var.sg_ssh_custom_port
      protocol    = "tcp"
      cidr_blocks = ["${var.sg_allow_ssh_subnet}"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.name}-custom"
    environment = "${var.name}"
  }
}
resource "aws_security_group" "main_security_group_basic1" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "sg_http_https"
  vpc_id = data.aws_vpc.vpc_data.id
  description = "opened http , https"

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.name}-http_https"
    environment = "${var.name}"
  }
}
resource "aws_security_group" "main_security_group_basic2" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "all_to_all"
  vpc_id = data.aws_vpc.vpc_data.id
  description = "open all to all"

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.name}-all_to_all"
    environment = "${var.name}"
  }
}
resource "aws_security_group" "main_security_group_basic3" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "ssh_to_all"
  vpc_id = data.aws_vpc.vpc_data.id
  description = "open ssh to all"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.name}-ssh_to_all"
    environment = "${var.name}"
  }
}