data "aws_ssm_parameter" "al2023_gp3_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

### Launch Template Configuration
resource "aws_launch_template" "app" {
  name_prefix = "dev-plan-"
  image_id = data.aws_ssm_parameter.al2023_gp3_ami.value
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [ var.sg_app_id ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y httpd
    echo "hello world! this is my dev plan app tier $(hostname)" > /var/www/html/index.html
    systemctl enable --now httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "dev-plan-app"
    }
  }
}

### AutoScaling Group configuration
resource "aws_autoscaling_group" "app_asg" {
  max_size = 2
  min_size = 1
  desired_capacity = 2

  name = "dev-plan-app-asg"
  vpc_zone_identifier = [ var.subnet_private_app_id ]

  health_check_type = "ELB"
  health_check_grace_period = 60
  target_group_arns = [ var.elb_app_target_group_arn ]

  launch_template {
    id = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "dev-plan-asg-member"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Only initiates a scaling operation when CPU exceeds 50% utilization. Otherwise, only 1 instance is deployed
resource "aws_autoscaling_policy" "cpu_tracking_50" {
    name = "cpu-50"
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    policy_type = "TargetTrackingScaling"

    target_tracking_configuration {
      target_value = 50

      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
    }
  
}

### IAM instance profile configuration

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

resource "aws_iam_role_policy_attachment" "ssm_readonly" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}