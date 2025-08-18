data "aws_ssm_parameter" "al2023_gp3_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_instance" "web_app" {
  ami = data.aws_ssm_parameter.al2023_gp3_ami.value
  instance_type = var.instance_type
  security_groups = [ aws_security_group.public_web.id ]
  subnet_id = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.public_web.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    echo "hello world! host: $(hostname)" > /var/www/html/index.html
    systemctl enable --now httpd
  EOF

  tags = {
    Name = "dev-plan-web-app-1"
    Purpose = "dev plan"
  }
}

### Security Groups - Public

resource "aws_security_group" "public_web" {
  name = "public-sg"
  description = "Enables public web ingress (HTTPS)"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "public_ingress_rule" {
  security_group_id = aws_security_group.public_web.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols
  security_group_id = aws_security_group.public_web.id
  cidr_ipv4 = "0.0.0.0/0"
}

### Security Groups - Private

# resource "aws_security_group" "private_ssh" {
#   name = "private-ssh"
#   description = "Enables SSH ingress (private)"
#   vpc_id = var.vpc_id
# }

# resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
#   security_group_id = aws_security_group.private_ssh.id
#   ip_protocol = "tcp"
#   from_port = 22
#   to_port = 22
#   cidr_ipv4 = "0.0.0.0/0"
# }

### IAM

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

resource "aws_iam_role" "ec2_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  name = "dev-plan-ec2-ssm-role"
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "dev-plan-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}