output "vpc_id" {
  value = aws_vpc.primary.id
}

output "subnet_public_id" {
  value = aws_subnet.public.id
}

output "subnet_private_app_id" {
  value = aws_subnet.private-app.id
}

output "subnet_db_private_id_az1" {
  value = aws_subnet.private-db-a.id
}

output "subnet_db_private_id_az2" {
  value = aws_subnet.private-db-b.id
}

output "subnet_public_b_id" {
  value = aws_subnet.public_b.id
}