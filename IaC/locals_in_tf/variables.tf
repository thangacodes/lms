variable "region" {
  description = "The region, where you wanted to spinup services"
  default     = "ap-south-1"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the resources that we provision in AWS account"
  type        = map(string)
  default = {
    CreationDate = "16/07/2023"
    Costcentre   = "1000560"
    Environment  = "Development"
    Owner        = "Thangadurai.Murugan@example.com"
    Project      = "DevOps_Engineering"
  }
}

variable "cidr_range" {
  description = "IP Range with subnet specified"
  default     = "192.168.0.0/16"
}
variable "ssh_key" {
  description = "To connect Remote machines using private file"
  default     = "admin"
  type        = string
}

variable "ins_spec" {
  description = "Specifying vm types"
  default     = "t2.micro"
  type        = string
}

variable "image_id" {
  description = "Specifying Image name"
  default     = "ami-012b9156f755804f5"
  type        = string
}
variable "security_group" {
  description = "Specifying the security group to associate with an EC2"
  default     = ["sg-0fb1052b659369aa8"]
  type        = list(string)
}

