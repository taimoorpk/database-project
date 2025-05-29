variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "my_ip" {
  description = "Your public IP for database access"
  type        = string
}