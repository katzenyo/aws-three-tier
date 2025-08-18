resource "aws_db_instance" "database" {
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_name = "development_plan_db"
  engine = "postgres"
  username = "devplan_admin"
  password = var.db_password
  vpc_security_group_ids = [ aws_security_group.db_security_group.id ]
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
}

### Security groups

resource "aws_security_group" "db_security_group" {
  name = "rds_security_group"
  description = "Allow PostgreSQL from web"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "public_ingress_rule" {
  security_group_id = aws_security_group.db_security_group.id
  ip_protocol = "tcp"
  from_port = 5432
  to_port = 5432
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
}

### Subnet groups

resource "aws_db_subnet_group" "db_subnets" {
  subnet_ids = [ var.subnet_private_id_az1, var.subnet_private_id_az2 ]
}