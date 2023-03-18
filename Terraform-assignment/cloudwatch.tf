provider "aws" {
  region = "us-east-1" # Change this to the region you want to use
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "example-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors CPU usage"
  alarm_actions       = ["${aws_sns_topic.example.arn}"]

  dimensions = {
    InstanceId = "${aws_instance.example.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name          = "example-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors memory usage"
  alarm_actions       = ["${aws_sns_topic.example.arn}"]

  dimensions = {
    InstanceId = "${aws_instance.example.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check" {
  alarm_name          = "example-status-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric monitors status check failures"
  alarm_actions       = ["${aws_sns_topic.example.arn}"]

  dimensions = {
    InstanceId = "${aws_instance.example.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "network" {
  alarm_name          = "example-network"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "1000000"
  alarm_description   = "This metric monitors network usage"
  alarm_actions       = ["${aws_sns_topic.example.arn}"]

  dimensions = {
    InstanceId = "${aws_instance.example.id}"
  }
}

resource "aws_sns_topic" "example" {
  name = "example"
}
