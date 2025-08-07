variable "db_password" {
  description = "Database password for admin user"
  type = string
  sensitive = true
}

variable "vpc_id" {
  description = "VPC ID for RDS security group"
  type = string
}

variable "subnet_private_id" {
  description = "Private subnet ID"
  type = string
}