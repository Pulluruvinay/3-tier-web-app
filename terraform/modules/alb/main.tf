resource "aws_lb" "main" {
  load_balancer_type = "application"
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "main" {
  name        = "three-tier-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" 

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
