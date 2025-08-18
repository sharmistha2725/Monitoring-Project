# variable "private_subnet_id" {}
# variable "ecs_sg_id" {}
# variable "key_name" {}

variable "ami" {
  type        = string
  description = "AMI ID for ECS nodes"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID for ECS nodes"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs across AZs"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "min_size" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 4
}

variable "desired_capacity" {
  type        = number
  default     = 2
}
