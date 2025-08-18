variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_eks_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "monitoring_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "key_name" {
  description = "Existing AWS Key Pair name for SSH"
}

variable "db_username" {
  description = "Master username for RDS"
}

variable "db_password" {
  description = "Master password for RDS"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  default     = "projectdb"
}

variable "alert_email" {
  description = "The email address to receive SNS alerts"
  type        = string
}

variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}

variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "root_volume_size"{
  type = number
}

variable "ec2_volume_size"{
  type = number
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "eks_cluster_role_name" { type = string }
variable "eks_cluster_trusted_services" { type = list(string) }
variable "eks_cluster_policy_arns" { type = list(string) }

variable "eks_node_role_name" { type = string }
variable "eks_node_trusted_services" { type = list(string) }
variable "eks_node_policy_arns" { type = list(string) }

variable "ecs_role_name" { type = string }
variable "ecs_trusted_services" { type = list(string) }
variable "ecs_policy_arns" { type = list(string) }

variable "rds_role_name" { type = string }
variable "rds_trusted_services" { type = list(string) }
variable "rds_policy_arns" { type = list(string) }
variable "node_instance_type"{type = string}
variable "desired_size"{type = number}
variable "min_size"{type = number}
variable "max_size" {type = number}


variable "ecs_cluster_name" {type = list(string)}
variable "ecs_min_size" {
  default = 2
}
variable "ecs_max_size" {
  default = 4
}
variable "ecs_desired_capacity" {
  default = 2
}

# Include VPC/subnets vars from your existing root variables
