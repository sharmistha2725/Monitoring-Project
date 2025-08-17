resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.aws_eks_cluster_role

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [var.security_group_id]
    endpoint_public_access = true
  }

}


resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.aws_eks_node_role
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.node_instance_type]

 
  tags = {
    Name = "${var.cluster_name}-node"
  }
}
