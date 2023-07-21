variable "region" {
  type        = string
  description = "AWS region where we deploy/provision resources"
  default     = "ap-south-1"
}

variable "common_tags" {
  type        = map(string)
  description = "Commonly assigning this tag set to the resources that we identify easily"
  default = {
    Environment  = "Development"
    CreationDate = "19/07/2023"
    Owner        = "Thangadurai.Murugan@example.com"
    Costcentre   = "1000456"
  }
}






