output "app_public_ip" {
  value = aws_instance.web_app.public_ip
  description = "Public IP of the dev plan EC2 instance"
}

output "aws_instance_app_id" {
  value = aws_instance.web_app.id
  description = "ID of the public web app EC2 instance"
}

output "aws_ssm_ami_value" {
  value = data.aws_ssm_parameter.al2023_gp3_ami.value
  description = "AMI value for the latest GP3 instance from SSM"
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}