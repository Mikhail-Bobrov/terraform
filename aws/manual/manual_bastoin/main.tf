resource "aws_key_pair" "mykeypair" {
  key_name   = "bastoni-key-${var.name}"
  public_key = file("ssh/mykey.pub")
}
resource "aws_launch_template" "bastion" {
  name_prefix = "bastion_${var.name}"
  image_id = var.image_aim
  instance_type = var.instance_type
  key_name = aws_key_pair.mykeypair.key_name

  user_data = file("test.sh")

  vpc_security_group_ids = [
    "sg-042798d59fb97094d"
  ]
  instance_market_options {
      market_type = var.instance_market
  }
  lifecycle {
    create_before_destroy = false
  }
}
resource "aws_autoscaling_group" "bastion" {
  name = "asg_bastion_${var.name}"
  #availability_zones = ["eu-west-2c"]
  vpc_zone_identifier = ["subnet-042a1c577590d7f60"]

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
