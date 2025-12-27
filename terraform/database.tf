
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

resource "aws_db_instance" "strapi" {
  identifier              = "postgres-database-iden"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.large"
  allocated_storage       = 20

  db_name                 = "strapi"
  username                = "strapi"
  password                = "StrapiPassword123!"
  port                    = 5432

  publicly_accessible     = true
  skip_final_snapshot     = true

  vpc_security_group_ids  = [aws_security_group.strapi_sg2.id] 

}
