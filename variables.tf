variable "region" {
    default = "us-east-1"
}

variable "ami_id" {
    description = "Amazon Linux 2 AMI ID for region"
    default = "tbd"
}

variable "db_pwd" {
    description = "Database password"
    type = string
    sensitive = true
}

variable "vpc_cidr" {
  description = "Default VPC CIDR block"
  type = string
  default = "10.0.0.0/16"
}