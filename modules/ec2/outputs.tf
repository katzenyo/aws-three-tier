output "app_public_ip" {
  value = aws_instance.web_app.public_ip
  description = "Public IP of the dev plan EC2 instance"
}

output "aws_instance_app_id" {
  value = aws_instance.web_app.id
  description = "ID of the public web app EC2 instance"
}