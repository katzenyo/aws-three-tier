moved {
  from = aws_vpc_security_group_ingress_rule.sg_alb_web_allow_tcp_ipv4
  to = module.alb.aws_vpc_security_group_ingress_rule.sg_alb_web_allow_tcp_ipv4
}

moved {
  from = aws_vpc_security_group_egress_rule.sb_alb_web_allow_all_ipv4
  to = module.alb.aws_vpc_security_group_egress_rule.sb_alb_web_allow_all_ipv4
}

moved {
  from = aws_vpc_security_group_ingress_rule.sg_app_allow_http_ipv4
  to = module.alb.aws_vpc_security_group_ingress_rule.sg_app_allow_http_ipv4
}

moved {
  from = aws_vpc_security_group_egress_rule.sg_app_allow_all_outbound
  to = module.alb.aws_vpc_security_group_egress_rule.sg_app_allow_all_outbound
}

moved {
  from = module.ec2.aws_iam_instance_profile.ec2_profile
  to = module.asg.aws_iam_instance_profile.ec2_profile
}

moved {
  from = module.ec2.aws_iam_role.ec2_role
  to = module.alb.aws_iam_role.ec2_role
}

moved {
  from = aws_lb_target_group.app_target_group
  to = module.alb.aws_lb_target_group.app_target_group
}

moved {
  from = aws_security_group.sg_app
  to = module.alb.aws_security_group.sg_app
}