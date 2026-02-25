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

# Architecture

<img width="859" height="665" alt="image" src="https://github.com/user-attachments/assets/8c43f4cc-4d79-41e2-a933-f7e76c6d025f" />


