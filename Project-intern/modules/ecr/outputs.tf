output "repository_url" {
  description = "Repository URL"
  value       = aws_ecr_repository.foo.repository_url
}
 
output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.foo.arn
}