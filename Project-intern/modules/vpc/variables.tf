variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_eks_subnet_cidrs" { type = list(string) }
variable "monitoring_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
