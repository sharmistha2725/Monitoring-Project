variable "cluster_name" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "node_instance_type" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}
variable "aws_eks_cluster_role"{}
variable "aws_eks_node_role"{}
variable "security_group_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}