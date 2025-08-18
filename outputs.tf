output "vpc_id" {
  value = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_id" {
  value = module.vpc.subnet_public_id
  description = "Public subnet ID"
}

output "private_app_subnet_id" {
  value = module.vpc.subnet_private_app_id
  description = "Private app subnet ID"
}

output "private_db_subnet_id_a" {
  value = module.vpc.subnet_db_private_id_az1
  description = "Private DB subnet ID (A)"
}

output "private_db_subnet_id_b" {
  value = module.vpc.subnet_db_private_id_az2
  description = "Private DB subnet ID (B)"
}