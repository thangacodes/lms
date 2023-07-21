resource "aws_network_acl" "s3_pvt_access" {
  vpc_id = aws_vpc.s3_testing.id
}

resource "aws_network_acl_rule" "ingressrule" {
  network_acl_id = aws_network_acl.s3_pvt_access.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"

  cidr_block = "192.168.0.0/16"
  from_port  = 1024
  to_port    = 65535
}

resource "aws_network_acl_rule" "egressrule" {
  network_acl_id = aws_network_acl.s3_pvt_access.id
  rule_number    = 300
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"

  cidr_block = "192.168.0.0/16"
  from_port  = 1024
  to_port    = 65535
}
