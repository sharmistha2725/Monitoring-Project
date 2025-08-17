variable "instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    key_name                    = string
    vpc_security_group_ids      = list(string)
    associate_public_ip_address = bool
    user_data                   = string
    tags                        = map(string)
    root_volume_size            = number
  }))
}