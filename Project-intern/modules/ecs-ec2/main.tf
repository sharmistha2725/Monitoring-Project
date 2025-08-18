# resource "aws_instance" "ecs_ec2" {
#   ami           = "ami-0fc5d935ebf8bc3bc" 
#   instance_type = "t3.medium"
#   subnet_id     = var.private_subnet_id
#   key_name      = var.key_name
#   vpc_security_group_ids = [var.ecs_sg_id]
#   associate_public_ip_address = false

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras enable nginx1
#               sudo yum install -y nginx
#               echo "<h1>Hello from ECS EC2 Dummy App</h1>" | sudo tee /usr/share/nginx/html/index.html
#               sudo systemctl enable nginx
#               sudo systemctl start nginx
#               EOF

#   tags = {
#     Name = "ecs-ec2-dummy"
#   }

  
# }


resource "aws_launch_template" "ecs_node_lt" {
  name_prefix   = "ecs-node-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.ecs_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
              sudo yum update -y
              sudo amazon-linux-extras enable nginx1
              sudo yum install -y nginx
              echo "<h1>Hello from ECS EC2 Dummy App</h1>" | sudo tee /usr/share/nginx/html/index.html
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
              )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-ec2-node"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "ecs-node-asg"
  launch_template {
    id      = aws_launch_template.ecs_node_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier        = var.private_subnet_ids
  min_size                   = var.min_size
  max_size                   = var.max_size
  desired_capacity           = var.desired_capacity
  health_check_type          = "EC2"
  force_delete               = true
  wait_for_capacity_timeout  = "10m"

  tag {
    key                 = "Name"
    value               = "ecs-ec2-node"
    propagate_at_launch = true
  }
}
