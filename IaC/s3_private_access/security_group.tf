### Security group public vm's ######
resource "aws_security_group" "public" {
  name        = "PUBLIC_VM_SGP"
  description = "Public internet access and SSH"
  vpc_id      = aws_vpc.s3_testing.id
  tags        = merge(var.common_tags, { Name = "PUBLIC_VM_SGP" })
}
resource "aws_security_group_rule" "public_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

##### Security_group for private vm's ########
resource "aws_security_group" "private" {
  name        = "PRIVATE_VM_SGP"
  description = "Private S3 bucket access and ssh via public vm"
  vpc_id      = aws_vpc.s3_testing.id
  tags        = merge(var.common_tags, { Name = "PRIVATE_VM_SGP" })
}
resource "aws_security_group_rule" "private_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}
resource "aws_security_group_rule" "private_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.s3_testing.cidr_block]
  security_group_id = aws_security_group.private.id
}
