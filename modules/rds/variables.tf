variable "db_password" {
  description = "Database password for admin user"
  type = string
  sensitive = true
}

variable "vpc_id" {
  description = "VPC ID for RDS security group"
  type = string
}

variable "subnet_private_id_az1" {
  description = "Private subnet A ID"
  type = string
}

variable "subnet_private_id_az2" {
  description = "Private subnet B ID"
  type = string
}

variable "security_group_app_id" {
  description = "ID of the application security group"
  type = string
}