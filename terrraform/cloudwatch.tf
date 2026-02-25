#####################################
# SNS Topic
#####################################

resource "aws_sns_topic" "alerts" {
  name = "cpu-alerts"
}

#####################################
# Email Subscription
#####################################

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#####################################
# CloudWatch CPU Alarms (for_each)
#####################################

resource "aws_cloudwatch_metric_alarm" "cpu" {

  for_each = {
    frontend = aws_instance.frontend.id
    backend  = aws_instance.backend.id
  }

  alarm_name          = "${each.key}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 50

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 120
  statistic   = "Average"

  alarm_description = "Alarm when ${each.key} CPU exceeds 50%"

  dimensions = {
    InstanceId = each.value
  }

  alarm_actions             = [aws_sns_topic.alerts.arn]
  ok_actions                = [aws_sns_topic.alerts.arn]
  insufficient_data_actions = []

  treat_missing_data = "notBreaching"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
