variable "region" {
  default = "eu-central-1"
}

variable "ami" {
  description = "Ubuntu 22.04 LTS - Frankfurt"
  default     = "ami-0faab6bdbac9484ee"
}

variable "key_name" {
  description = "Name of your EC2 Key Pair"
  type = string
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email to receive CloudWatch alerts"
  type        = string
  default     = "esraaghazal155@gmail.com"
}