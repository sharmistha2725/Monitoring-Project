variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_sg_id" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "db_name" {}
variable "monitoring_role_arn" {
  
}
