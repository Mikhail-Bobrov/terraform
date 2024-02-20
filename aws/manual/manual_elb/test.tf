#manual instance and elb for it
output dns_name {
  value       = aws_lb.my_app.dns_name
}

resource "aws_lb_target_group" "my_app" {
  name       = "my-app"
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = "vpc-0108dbaabba0c6580"
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8080
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group_attachment" "my_app" {
  target_group_arn = aws_lb_target_group.my_app.arn
  target_id        = "i-031eeb410b50b1035"
  port             = 8080
}
resource "aws_lb_target_group_attachment" "my_app2" {
  target_group_arn = aws_lb_target_group.my_app.arn
  target_id        = "i-00311750ad44a6a21"
  port             = 8080
}
resource "aws_lb" "my_app" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-066817c408d25e3c4"]

  # access_logs {
  #   bucket  = "my-logs"
  #   prefix  = "my-app-lb"
  #   enabled = true
  # }

  subnets = ["subnet-0138dd8bd185bcf0f","subnet-0b59ec60d494dcf05"]
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app.arn
  }
}
resource "aws_lb_target_group" "my_app_int" {
  name       = "my-appinternal"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = "vpc-0108dbaabba0c6580"
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group_attachment" "my_app_int" {
  target_group_arn = aws_lb_target_group.my_app_int.arn
  target_id        = "i-0ca6d6832806e6755"
  port             = 80
}
resource "aws_lb_target_group_attachment" "my_app2_int" {
  target_group_arn = aws_lb_target_group.my_app_int.arn
  target_id        = "i-09a46ff0345482fd2"
  port             = 80
}
# resource "aws_lb_listener" "http_int" {
#   load_balancer_arn = aws_lb.my_app.arn
#   port              = "8080"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_app_int.arn
#   }
# }
resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_int.arn
  }

  condition {
    host_header {
      values = ["mydns.com"]
    }
  }
}
resource "aws_lb_listener_rule" "path_based_routing" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_int.arn
  }

  condition {
    path_pattern {
      values = ["/test"]
    }
  }
}