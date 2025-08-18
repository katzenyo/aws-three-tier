# SG ALB: Internet > ALB connection, public security group + ingress/egress rules

resource "aws_security_group" "sg_alb_web" {
  name = "dev-plan-sg-alb-web"
  description = "Allows HTTP to ALB"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "dev-plan-sg-alb-web"
    Purpose = "dev plan"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_alb_web_allow_tcp_ipv4" {
  security_group_id = aws_security_group.sg_alb_web.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80

  tags = {
    Name = "dev-plan-sg-alb-web-ingress"
    Purpose = "dev plan"
  }
}

resource "aws_vpc_security_group_egress_rule" "sb_alb_web_allow_all_ipv4" {
  security_group_id = aws_security_group.sg_alb_web.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  # from_port = 0
  # to_port = 0

  tags = {
    Name = "dev-plan-sg-alb-web-egress"
    Purpose = "dev plan"
  }
}

# App security group: ALB > EC2 connection

resource "aws_security_group" "sg_app" {
  name = "dev-plan-sg-app"
  description = "Enables web access to app EC2 via ALB"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_app_allow_tcp_ipv4" {
  security_group_id = aws_security_group.sg_app.id
  ip_protocol = "tcp"
  cidr_ipv4 = var.private_apps_cidr
  from_port = 80
  to_port = 80

  tags = {
    Name = "dev-plan-sg-app-ingress"
    Purpose = "dev plan"
  }
}

# Allowing outbound to internet, SSM for updates
resource "aws_vpc_security_group_egress_rule" "sg_app_allow_all_outbound" {
  security_group_id = aws_security_group.sg_app.id
  ip_protocol = "-1"
  # from_port = 0
  # to_port = 0
  cidr_ipv4 = "0.0.0.0/0"

  tags = {
    Name = "dev-plan-sg-app-egress"
    Purpose = "dev plan"
  }
}

# Database security group: App > DB connection
resource "aws_security_group" "sg_db" {
  name = "dev-plan-sg-db"
  description = "Allow Postgres from app security group"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "psql-from-app" {
  security_group_id = aws_security_group.sg_db.id
  cidr_ipv4 = var.private_db_cidr
  ip_protocol = "tcp"
  from_port = 5432
  to_port = 5432
  
  tags = {
    Name = "psql-sg-ingress"
    Purpose = "dev plan"
  }
}

resource "aws_vpc_security_group_egress_rule" "psql-allow-all" {
  security_group_id = aws_security_group.sg_db.id
  ip_protocol = "-1"
  # to_port = 0
  # from_port = 0
  cidr_ipv4 = "0.0.0.0/0"

  tags = {
    Name = "psql-sg-egress"
    Purpose = "dev plan"
  }
}