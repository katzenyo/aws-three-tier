resource "aws_db_instance" "database" {
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_name = "development_plan_postgres"
  engine = "postgres"
  username = "postgres"
  password = var.db_password

  vpc_security_group_ids = [ aws_security_group.db_security_group.id ]
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  publicly_accessible = false

  # for testing environment
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "dev-plan-postgres"
    Purpose = "dev plan"
  }
}

### Security groups

resource "aws_security_group" "db_security_group" {
  name = "rds_security_group"
  description = "Allow PostgreSQL from web"
  vpc_id = var.vpc_id
  tags = {
    Name = "dev-plan-rds-sg"
    Purpose = "dev plan"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id = aws_security_group.db_security_group.id
  referenced_security_group_id = var.security_group_app_id
  ip_protocol = "tcp"
  from_port = 5432
  to_port = 5432
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
}

### Subnet groups

resource "aws_db_subnet_group" "db_subnets" {
  name = "dev-plan-db-subnets"
  subnet_ids = [ var.subnet_private_id_az1, var.subnet_private_id_az2 ]
  tags = {
    Name = "dev-plan-db-subnets"
    Purpose = "dev plan"
  }
}