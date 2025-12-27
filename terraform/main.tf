
# Get default VPC
data "aws_vpcs" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

locals {
  default_vpc_id = data.aws_vpcs.default.ids[0]
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [local.default_vpc_id]
  }
}


# Security Group
resource "aws_security_group" "strapi_sg" {
  name   = "strapi-docker-sg1"
  vpc_id = local.default_vpc_id

  ingress {
    from_port      = 1337
    to_port        = 1337
    protocol       = "tcp"
    security_groups    = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port        = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "strapi" {
  name                     = "/ecs/logs-store"
  retention_in_days = 7
}


