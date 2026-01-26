# Architecture
2 EC2 Instances

One EC2 instance for the Frontend

One EC2 instance for the Backend

Amazon RDS

Used as the database layer

Amazon CloudWatch

Monitors CPU utilization

Sends email notifications when CPU usage exceeds a defined threshold

# Technologies
Terraform – Infrastructure as Code (IaC)

AWS EC2 – Compute resources

AWS RDS – Managed relational database

AWS CloudWatch – Monitoring and alerting

SNS (Simple Notification Service) – Email notifications

# Infrastructure Details

Terraform is used to:

Provision EC2 instances in public subnet

Configure RDS database in a private subnet

Configure VPC with private & public subnet

Set up CloudWatch alarms for CPU monitoring

CloudWatch alarms trigger SNS notifications that send alerts to an email address when CPU usage is high.

