resource "aws_lb" "web_alb" {
  name = "web_alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.web_alb_sg_public ]
}

### Security Groups

resource "aws_security_group" "web_alb_sg_public" {
  name = "web_alb_sg_public"
  description = "Public security group for web Application Load Balancer"
  vpc_id = var.vpc_id
}

resource "aws_security_group_" "public_ingress_rule" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4 = "0.0.0.0/0"
}