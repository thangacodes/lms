provider "aws" {
  alias  = "peer"
  region = "ap-south-1"
}


resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_vpc" "peer" {
  provider   = aws.peer
  cidr_block = "192.168.0.0/16"
}

data "aws_caller_identity" "peer" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = aws_vpc.peer.id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = "ap-south-1"
  auto_accept   = false
  tags          = merge(var.common_tags, { Name = "Requester" })
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = merge(var.common_tags, { Name = "Accepter" })
}
