provider "aws" {
  region = "us-east-1" # Change this to the region you want to use
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0c55b159cbfafe1f0" # Change this to the ID of the AMI you want to use
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.example.id}"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
}

resource "aws_security_group" "example" {
  name_prefix = "example"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  name = "example"
  launch_configuration = "${aws_launch_configuration.example.id}"
  min_size = 2
  max_size = 5
  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  target_group_arns = ["${aws_lb_target_group.example.arn}"]

  tag {
    key = "Name"
    value = "example"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  metric {
    name = "CPUUtilization"
    namespace = "AWS/EC2"
    unit = "Percent"
  }

  scaling_policy {
    name = "example-policy"
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        target_value = 45.0
      }
    }
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.example.id}"
  cidr_block = "10.0.1.0/24" # Change this to the CIDR block you want to use
  availability_zone = "us-east-1a" # Change this to the availability zone you want to use
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16" # Change this to the CIDR block you want to use
}

resource "aws_lb_target_group" "example" {
  name = "example"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.example.id}"
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
    path = "/"
  }
}
