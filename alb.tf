### ALB, internet-facing

resource "aws_lb" "web" {
  name = "dev-plan-alb-web"
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg_alb_web.id]
  subnets = [ module.vpc.subnet_public_id, module.vpc.subnet_public_b_id ]
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
  vpc_id = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    matcher = "200-399"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
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

### Outputs

output "alb_dns_name" {
  value = aws_lb.web.dns_name
  description = "Public DNS name of the application load balancer"
}