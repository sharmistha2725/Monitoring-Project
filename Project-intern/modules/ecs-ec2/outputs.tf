# output "ecs_ec2_private_ip" {
#   value = aws_instance.ecs_ec2.private_ip
# }

output "asg_name" {
  value       = aws_autoscaling_group.ecs_asg.name
  description = "Name of the ECS ASG"
}

output "launch_template_id" {
  value       = aws_launch_template.ecs_node_lt.id
  description = "Launch template ID for ECS nodes"
}
