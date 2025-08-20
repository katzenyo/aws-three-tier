variable "subnet_private_app_id" {
  description = "Subnet private app ID"
  type = string
}

variable "elb_app_target_group_arn" {
  description = "ELB app target group ARN value"
  type = string
}

variable "aws_ssm_ami_value" {
  type = string
  description = "AMI value for latest GP3 instance from SSM"
}

variable "iam_instance_profile_name" {
  type = string
  description = "IAM EC2 instance profile name"
}

variable "sg_app_id" {
  type = string
  description = "App security group ID"
}