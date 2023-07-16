output "web_publicip" {
  value = aws_instance.web.public_ip
}
output "web_publicdns" {
  value = aws_instance.web.public_dns
}
output "web_privateip" {
  value = aws_instance.web.private_ip
}
output "vpc_tagging" {
  value = local.tags
}
output "ec2_tagging" {
  value = local.tagging
}
