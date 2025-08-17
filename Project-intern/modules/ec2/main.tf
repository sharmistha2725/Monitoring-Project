resource "aws_instance" "ec2" {
  for_each = var.instances

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  key_name                    = each.value.key_name
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  associate_public_ip_address = each.value.associate_public_ip_address
  user_data                   = each.value.user_data
  tags                        = each.value.tags

  root_block_device {
    volume_type = "gp3"
    volume_size = each.value.root_volume_size
    encrypted   = true
  }
}