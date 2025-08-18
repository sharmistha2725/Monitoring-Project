variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the ECS service (Fargate tasks)"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID for ECS tasks"
}

variable "desired_count" {
  type        = number
  default     = 2
  description = "Number of ECS tasks to run"
}

variable "task_cpu" {
  type        = string
  default     = "256"
  description = "CPU units for the ECS task"
}

variable "task_memory" {
  type        = string
  default     = "512"
  description = "Memory for the ECS task"
}

variable "nginx_image" {
  type        = string
  default     = "nginx:latest"
  description = "Docker image for Nginx container"
}

variable "assign_public_ip" {
  type        = bool
  default     = true
  description = "Assign public IP for Fargate tasks if subnets are public"
}
