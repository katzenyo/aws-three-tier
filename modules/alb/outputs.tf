output "alb_dns_name" {
  value = aws_lb.web.dns_name
  description = "Public DNS name of the application load balancer"
}

output "target_group_arn" {
  value = aws_lb_target_group.app_target_group.arn
  description = "ARN of the target group"
}

output "app_sg_id" {
  value = aws_security_group.sg_app.id
  description = "ID of the application security group"
}