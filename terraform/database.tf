# aws rds parameter group
resource "aws_db_parameter_group" "strapi_pg" {
  name   = "strapi-postgres15"
  family = "postgres15"

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "0"
  }

  parameter {
    name  = "statement_timeout"
    value = "0"
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = "60"
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = "30"
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = "10"
  }
}

# Security Group
resource "aws_security_group" "strapi_sg2" {
  name   = "data-sg-for-database"
  vpc_id = local.default_vpc_id

  ingress {
    from_port      = 5432
    to_port        = 5432
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

# aws db subnet group
resource "aws_db_subnet_group" "strapi_db_subnet" {
  name       = "docker-strapi-db-subnet"
  subnet_ids = [
    "subnet-0c26626bb68ddcbd6",
    "subnet-0c60862e8ccf3b21a"
  ]

  tags = {
    Name = "postgres-strapi-db-subnet"
  }
}

resource "aws_db_instance" "strapi" {
  identifier              = "postgres-sql"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.small"
  allocated_storage       = 20

  db_name                 = "strapi"
  username                = "strapi"
  password                = "StrapiPassword123!"
  port                    = 5432

  publicly_accessible     = true
  skip_final_snapshot     = true

  vpc_security_group_ids  = [aws_security_group.strapi_sg2.id] 
  parameter_group_name = aws_db_parameter_group.strapi_pg.name

}
