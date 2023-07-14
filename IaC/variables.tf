variable "region" {
  default = "ap-south-1"
}
variable "server_name" {
  description = "Name for WebServer"
  type        = string
  default     = "Tomcat-Websvr"
}
variable "server_size" {
  description = "Server Size for WebServer"
  type        = string
  default     = "t2.micro"
}
