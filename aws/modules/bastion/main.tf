data "aws_vpc" "vpc_id" {
  filter {
    name = "tag:role"
    values = ["vpc"]
  }
  filter {
    name = "tag:project"
    values = ["${var.project}"]
  }
}
data "aws_subnet" "selecte_public_subnet" {
  filter {
    name   = "tag:subnet"
    values = [var.subnet_tag_name]
  }
}
resource "aws_key_pair" "mykeypair" {
  key_name   = "bastoni_${var.name}_key"
  public_key = file("${path.module}/ssh/mykey.pub")
}
resource "aws_launch_template" "bastion" {
  depends_on = [aws_eip.bastion_public_ip, aws_security_group.bastion_security_group] 
  name_prefix = "bastion_${var.name}_template"
  image_id = var.image_aim
  instance_type = var.instance_type
  key_name = aws_key_pair.mykeypair.key_name

  user_data = base64encode(templatefile("${path.module}/startup.sh", {
    ssh_port = var.ssh_port
  }))
  iam_instance_profile {
    name = aws_iam_instance_profile.aim_profile.name
  }
  vpc_security_group_ids = [
    aws_security_group.bastion_security_group.id
  ]
  instance_market_options {
      market_type = var.instance_market
  }
  lifecycle {
    create_before_destroy = false
  }
}
resource "aws_autoscaling_group" "bastion" {
  depends_on = [aws_launch_template.bastion] 
  name = "bastion_${var.name}_asg"
  #availability_zones = ["eu-west-2c"]
  vpc_zone_identifier = [data.aws_subnet.selecte_public_subnet.id]

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity

  tag {
    key = "Name"
    value = "bastion_${var.name}"
    propagate_at_launch = true
  }
  tag {
    key = "Role"
    value = "bastion"
    propagate_at_launch = true
  }
}
resource "aws_security_group" "bastion_security_group" {
  name   = "sg_ssh_bastion_${var.name}"
  vpc_id = data.aws_vpc.vpc_id.id
  description = "bastion ssh port ${var.ssh_port}"

  ingress {
    protocol  = "tcp"
    from_port = "${var.ssh_port}"
    to_port   = "${var.ssh_port}"
    cidr_blocks = ["${var.ssh_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg_bastion_${var.name}"
    environment = "${var.name}"
    role = "bastion"
  }
}