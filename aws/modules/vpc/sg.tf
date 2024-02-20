resource "aws_security_group" "main_security_group_basic1" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "sg_http_https_to_all"
  vpc_id = aws_vpc.vpc_main.id
  description = "opened http and https"

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
    env = "${var.env}"
    role = "sg"
  }
}
resource "aws_security_group" "main_security_group_basic2" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "all_to_all"
  vpc_id = aws_vpc.vpc_main.id
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
    env = "${var.env}"
    role = "sg"
  }
}
resource "aws_security_group" "main_security_group_basic3" {
  count = var.sg_basic_rules ? 1 : 0
  name   = "ssh_to_all"
  vpc_id = aws_vpc.vpc_main.id
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
    env = "${var.env}"
    role = "sg"
  }
}