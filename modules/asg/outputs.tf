output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}

output "aws_ssm_ami_value" {
  value = data.aws_ssm_parameter.al2023_gp3_ami.value
  description = "AMI value for the latest GP3 instance from SSM"
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}