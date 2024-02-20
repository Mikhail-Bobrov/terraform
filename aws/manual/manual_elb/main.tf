#autoscale group and elb for it
output dns_name {
  value       = aws_lb.example.dns_name
}
resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = ["subnet-0c20e97b57e41de9e", "subnet-0401a8387f9092cda"]
  security_groups    = ["sg-019bc7e13a9c19d72"]
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0f5ebe2a0133f84b7"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_launch_template" "lt_test" {
  name_prefix = "test_template"
  image_id = "ami-0e5f882be1900e43b"
  instance_type = "t2.micro"
  key_name = "test"

  vpc_security_group_ids = [
    "sg-019bc7e13a9c19d72"
  ]
#   instance_market_options {
#       market_type = "spot"
#   }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "asg_test" {
  name     = "asg_test"
  min_size = 1
  max_size = 3
  desired_capacity = 2

  force_delete  = true
  health_check_type = "ELB"
  health_check_grace_period  = 60

  vpc_zone_identifier = [
    "subnet-063961f3bdd3f73f8", "subnet-03e3fa9e9f72d52f7"
  ]

  target_group_arns = [aws_lb_target_group.asg.arn]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy               = "lowest-price"
      spot_instance_pools                    = 2
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.lt_test.id
      }
    }
  }
    tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
    tag {
    key                 = "role"
    value               = "web"
    propagate_at_launch = true
  }
}
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

