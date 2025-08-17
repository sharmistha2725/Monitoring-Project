variable "prometheus_repo_name" {
  description = "Name of the Prometheus ECR repository"
  type        = string
  default     = "prometheus"
}

variable "grafana_repo_name" {
  description = "Name of the Grafana ECR repository"
  type        = string
  default     = "grafana"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}