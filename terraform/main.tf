terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get current public IP automatically
data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip"
}

locals {
  # Clean the IP response and add /32 CIDR
  my_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}

resource "aws_db_instance" "postgres_db" {
  identifier             = "customers-orders-db"
  instance_class         = var.instance_class
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14.4"
  db_name                = "customers_orders"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres14"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  # Enable deletion protection in production
  deletion_protection = false
}

resource "aws_security_group" "db_sg" {
  name        = "customers-orders-db-sg"
  description = "Allow PostgreSQL access from current IP"

  ingress {
    description = "PostgreSQL from current IP"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr] # Uses automatically detected IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "customers-orders-db-access"
  }
}