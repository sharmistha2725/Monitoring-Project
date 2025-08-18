module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_eks_subnet_cidrs = var.private_eks_subnet_cidrs
  monitoring_subnet_cidrs  = var.monitoring_subnet_cidrs
  availability_zones       = var.availability_zones
}



module "ec2" {
  source = "./modules/ec2"
  instances = {
    bastion = {
      ami                         = "ami-0fc5d935ebf8bc3bc"
      instance_type               = "t3.micro"
      subnet_id                   = module.vpc.public_subnet_ids[0]
      key_name                    = var.key_name
      vpc_security_group_ids      = [module.bastion_sg.security_group_id]
      associate_public_ip_address = true
      user_data                   = ""
      tags                        = { Name = "bastion" }
      root_volume_size            = var.root_volume_size
    }
    app = {
      ami                         = "ami-0fc5d935ebf8bc3bc"
      instance_type               = "t3.medium"
      subnet_id                   = module.vpc.monitoring_subnet_ids[0]
      key_name                    = var.key_name
      vpc_security_group_ids      = [module.ecs_sg.security_group_id]
      associate_public_ip_address = false
      user_data                   = <<-EOF
        #!/bin/bash
        sudo yum update -y
        echo "<h1>EC2 App Running</h1>" > index.html
        nohup python3 -m http.server 8080 &
        EOF
      tags                        = { Name = "ec2-app" }
      root_volume_size            = var.ec2_volume_size
    }
  }
}

module "rds" {
  source              = "./modules/rds"
  private_subnet_ids  = module.vpc.monitoring_subnet_ids
  rds_sg_id           = module.rds_sg.security_group_id
  db_username         = var.db_username
  db_password         = var.db_password
  db_name             = var.db_name
  monitoring_role_arn = module.rds_role.role_arn
}

module "eks" {
  source                 = "./modules/eks"
  cluster_name           = "project-eks"
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_eks_subnet_ids
  security_group_id = module.eks_sg.security_group_id
  node_instance_type     = var.node_instance_type
  desired_size           = var.desired_size
  min_size               = var.min_size
  max_size               = var.max_size
  aws_eks_cluster_role = module.eks_cluster_role.role_arn
  aws_eks_node_role = module.eks_node_role.role_arn
  
}

module "aws_sns_topic" {
  source = "./modules/sns"
  alert_email           = var.alert_email
  sns_topic_name        = var.sns_topic_name
  environment           = var.environment
  application_name      = var.application_name
  owner                 = var.owner
 
}
 
module "ecr" {
  source = "./modules/ecr"
  scan_on_push = true
}

module "ecs-ec2" {
  source           = "./modules/ecs-ec2"
  ecs_cluster_name = var.ecs_cluster_name
  subnet_ids       = module.vpc.monitoring_subnet_ids
  ecs_sg_id        = module.ecs_sg.security_group_id
  desired_count    = var.ecs_desired_count
}


module "eks_cluster_role" {
  source           = "./modules/iam"
  role_name        = var.eks_cluster_role_name
  trusted_services = var.eks_cluster_trusted_services
  policy_arns      = var.eks_cluster_policy_arns
}

module "eks_node_role" {
  source           = "./modules/iam"
  role_name        = var.eks_node_role_name
  trusted_services = var.eks_node_trusted_services
  policy_arns      = var.eks_node_policy_arns
}

module "ecs_role" {
  source           = "./modules/iam"
  role_name        = var.ecs_role_name
  trusted_services = var.ecs_trusted_services
  policy_arns      = var.ecs_policy_arns
}

module "rds_role" {
  source           = "./modules/iam"
  role_name        = var.rds_role_name
  trusted_services = var.rds_trusted_services
  policy_arns      = var.rds_policy_arns
}

module "bastion_sg" {
  source      = "./modules/security-groups"
  name        = "bastion-sg"
  type        = "bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  ] 
  egress_rules = [ 
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } ]
  
}

module "eks_sg" {
  source      = "./modules/security-groups"
  name        = "eks-node-sg"
  type        = "eks"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
  {
    description = "Allow all internal VPC traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ] 
  
  egress_rules = [ {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } ]

}

module "ecs_sg" {
  source = "./modules/security-groups"
  name   = "ecs-sg"
  type   = "ecs"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [ 
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "App server (Python HTTP)"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [ 
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}



module "rds_sg" {
  source = "./modules/security-groups"
  name        = "rds-sg"
  type        = "rds"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [ {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }]

  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

}


// NACLS - when i did ansible could not access ec2-app from bastion
resource "aws_network_acl" "private_nacl" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.monitoring_subnet_ids  # attach to ec2-app subnet

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "10.0.0.0/16"   # allow SSH from bastion/VPC
    from_port  = 22
    to_port    = 22
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "10.0.0.0/16"   # allow ephemeral return traffic
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
