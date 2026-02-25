variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "key_name" {
  description = "Name of your EC2 Key Pair"
  type        = string
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email to receive CloudWatch alerts"
  type        = string
}
