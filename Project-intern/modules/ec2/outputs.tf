output "ec2_private_ip" {
  value = { for name, inst in aws_instance.ec2 : name => inst.private_ip }
}