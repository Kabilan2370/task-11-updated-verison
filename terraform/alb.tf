# security group for alb
resource "aws_security_group" "alb" {
  name        = "access-sg2"
  description = "Allow HTTP inbound"
  vpc_id      = local.default_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# application load balancer
resource "aws_lb" "strapi" {
  name               = "application-load-kabil"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets = ["subnet-0b5f44f6a7c3f2a17", "subnet-0dcf98e23a5861550","subnet-0342cfb028d6aff5a"]
}

# blue target group for application load balancer
resource "aws_lb_target_group" "blue_strapi" {
  name        = "fir-blue-target"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.default_vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# green target group for application load balancer
resource "aws_lb_target_group" "green_strapi" {
  name        = "sec-green-target"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.default_vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# load balancer listener attached with 2 target groups

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.strapi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_strapi.arn
  }
  
}
