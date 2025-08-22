### ALB, internet-facing

resource "aws_lb" "web" {
  name = "dev-plan-alb-web"
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg_alb_web.id]
  subnets = [ var.public_subnet_a_id, var.public_subnet_b_id ]
  idle_timeout = 60

  tags = {
    Name = "dev-plan-aws-alb-web"
    Purpose = "dev plan"
  }
}
### Target Group

resource "aws_lb_target_group" "app_target_group" {
  name = "dev-plan-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    matcher = "200-399"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "dev-plan-app-target-group"
    Purpose = "dev plan"
  }
}

### Listener

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}

### Attaching EC2 instance to the target group

# resource "aws_lb_target_group_attachment" "web-app-Attaching" {
#   target_group_arn = aws_lb_target_group.app_target_group.arn
#   target_id = module.ec2.aws_instance_app_id
#   port = 80
# }

### Security Groups

# SG ALB: Internet > ALB connection, public security group + ingress/egress rules

resource "aws_security_group" "sg_alb_web" {
  name = "dev-plan-sg-alb-web"
  description = "Allows HTTP to ALB"
  vpc_id = var.vpc_id

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
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_app_allow_http_ipv4" {
  security_group_id = aws_security_group.sg_app.id
  referenced_security_group_id = aws_security_group.sg_alb_web.id
  ip_protocol = "tcp"
  # cidr_ipv4 = var.private_apps_cidr
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