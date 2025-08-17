resource "aws_instance" "ecs_ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc" 
  instance_type = "t3.medium"
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.ecs_sg_id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable nginx1
              sudo yum install -y nginx
              echo "<h1>Hello from ECS EC2 Dummy App</h1>" | sudo tee /usr/share/nginx/html/index.html
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "ecs-ec2-dummy"
  }

  
}
