resource "aws_ecr_repository" "prometheus" {
  name                 = var.prometheus_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = {
    Name = var.prometheus_repo_name
  }
}

resource "aws_ecr_repository" "grafana" {
  name                 = var.grafana_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = {
    Name = var.grafana_repo_name
  }
}
