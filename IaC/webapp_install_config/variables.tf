variable "region" {
  description = "The region where you are deploying AWS resources"
  type        = string
  default     = "ap-south-1"
}


variable "server_name" {
  description = "Name for WebServer"
  type        = string
  default     = "Tomcat-Web"
}


variable "server_size" {
  description = "Server Size for WebServer"
  type        = string
  default     = "t2.micro"
}
variable "key_name" {
  description = "SSH key for the server"
  type        = string
  default     = "admin"
}

variable "taggy" {
  description = "Tags for the resources that we create"
  type        = map(string)
  default = {
    Owner        = "Thangadurai.Murugan@example.com"
    CreationDate = "13/07/2023"
    Location     = "India"
    Project      = "Usecase"
  }
}
