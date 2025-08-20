### Launch Template Configuration
resource "aws_launch_template" "app" {
  name_prefix = "dev-plan-"
  image_id = var.aws_ssm_ami_value
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.iam_instance_profile_name
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

# Initiates a scaling operation when CPU exceeds 50% utilization
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