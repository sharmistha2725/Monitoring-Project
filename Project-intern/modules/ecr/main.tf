resource "aws_ecr_repository" "foo" {
  name                 = "my-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = {
    Name        = "my-repo"
  }
}