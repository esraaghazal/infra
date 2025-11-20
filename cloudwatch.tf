
## making a sns alert
# take the alarm from cloudwatch and then spreat it  
resource "aws_sns_topic" "alerts" {
  name = "cpu-alerts"
}

# subscriping in sns and send as email 
# first time you will reseve the verification email you should click on the link
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}


# make more than one cloudwatch by using for_each
resource "aws_cloudwatch_metric_alarm" "cpu" {
  for_each = {
    frontend = aws_instance.frontend.id
    backend  = aws_instance.backend.id
  }
    alarm_name = "${each.key}-high-cpu"
    # send the alarm when it is Greater Than Or Equal To Threshold
    comparison_operator = "GreaterThanOrEqualToThreshold"
    # it will check twice before sending the alarm
    evaluation_periods = 2
    # watch the matric of the ec2 namespace 
    metric_name = "CPUUtilization"
    namespace   = "AWS/EC2"
    # every 2 min calculate the average of CPU 
    period    = 120
    statistic = "Average"
    # if the average is greater than or equal 50 send alarm 
    threshold = 50
    # if threshold = 50 send sns to the subscriper
    alarm_actions = [aws_sns_topic.alerts.arn]
    # provide the instance that has the metric
    dimensions = { InstanceId = each.value }
    }