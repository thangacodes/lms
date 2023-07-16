output "web_public_ip" {
  value = aws_instance.web.public_ip
}
output "web_private_ip" {
  value = aws_instance.web.private_ip
}

output "public_endpoint" {
  value = "http://${aws_instance.web.public_ip}:8080/lms/"
}
output "private_endpoint" {
  value = "http://${aws_instance.web.private_ip}:8080/lms/"
}

output "role_name_finding" {
  value = aws_iam_role.demo_role.name
}
output "policy_name" {
  value = aws_iam_policy.demo_s3_policy.name
}
output "ec2_profile_name" {
  value = aws_iam_instance_profile.demo_profile.name
}
