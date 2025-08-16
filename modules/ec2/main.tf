resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  security_groups = [ aws_security_group.public_web.id, aws_security_group.private_ssh.id ]
  subnet_id = subnet_public_id
}

### Security Groups - Public

resource "aws_security_group" "public_web" {
  name = "public-sg"
  description = "Enables public web ingress (HTTPS)"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "public_ingress_rule" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4 = "0.0.0.0/0"
}

### Security Groups - Private

resource "aws_security_group" "private_ssh" {
  name = "private-ssh"
  description = "Enables SSH ingress (private)"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id = aws_security_group.private_ssh.id
  ip_protocol = "ssh"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

### Auto-Scaling Groups

resource "aws_autoscaling_group" "ec2_asg" {
  max_size = 3
  min_size = 1
}