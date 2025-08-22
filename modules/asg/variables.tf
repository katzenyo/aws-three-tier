variable "subnet_private_app_id" {
  description = "Subnet private app ID"
  type = string
}

variable "elb_app_target_group_arn" {
  description = "ELB app target group ARN value"
  type = string
}

variable "sg_app_id" {
  type = string
  description = "App security group ID"
}