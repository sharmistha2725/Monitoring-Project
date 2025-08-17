output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_eks_subnet_ids" {
  description = "IDs of private EKS subnets"
  value       = aws_subnet.private_eks[*].id
}

output "monitoring_subnet_ids" {
  description = "IDs of monitoring subnets"
  value       = aws_subnet.monitoring[*].id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = aws_nat_gateway.nat[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "eks_az1_route_table_id" {
  description = "Route table ID for EKS subnet AZ1"
  value       = aws_route_table.eks_az1.id
}

output "eks_az2_route_table_id" {
  description = "Route table ID for EKS subnet AZ2"
  value       = aws_route_table.eks_az2.id
}

# output "monitoring_route_table_id" {
#   description = "Route table ID for monitoring subnets"
#   value       = aws_route_table.monitoring.id
# }