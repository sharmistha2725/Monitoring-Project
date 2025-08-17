output "prometheus_repository_url" {
  description = "Prometheus ECR repository URL"
  value       = aws_ecr_repository.prometheus.repository_url
}

output "grafana_repository_url" {
  description = "Grafana ECR repository URL"
  value       = aws_ecr_repository.grafana.repository_url
}
