resource "aws_vpc" "s3_testing" {
  cidr_block = "192.168.0.0/16"
  tags       = merge(var.common_tags, { Name = "S3-PRIVATE-VPC" })
}

locals {
  privaterange = {
    "ap-south-1a" = "192.168.1.0/24"
    "ap-south-1b" = "192.168.2.0/24"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = local.privaterange
  cidr_block        = each.value
  vpc_id            = aws_vpc.s3_testing.id
  availability_zone = each.key
  tags              = merge(var.common_tags, { Name = "Private-Subnet-1${substr(each.key, -1, 1)}" })
}

locals {
  publicrange = {
    "ap-south-1a" = "192.168.3.0/24"
    "ap-south-1b" = "192.168.4.0/24"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each          = local.publicrange
  cidr_block        = each.value
  vpc_id            = aws_vpc.s3_testing.id
  availability_zone = each.key
  tags              = merge(var.common_tags, { Name = "Public-Subnet-1${substr(each.key, -1, 1)}" })
}

#### AWS INTERNET GATEWAY ###########
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.s3_testing.id

  tags = merge(var.common_tags, { Name = "Public_Internet_Gateway" })
}

############## Route table for public #########
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.s3_testing.id
  tags   = merge(var.common_tags, { Name = "Public_Route_Table" })
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.s3_testing.id
  tags   = merge(var.common_tags, { Name = "Private_Route_Table" })
}

resource "aws_route_table_association" "private_sub_assoc" {
  for_each       = local.privaterange
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.Private_RT.id
}
resource "aws_route_table_association" "public_sub_assoc" {
  for_each       = local.publicrange
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.Public_RT.id
}
resource "aws_route" "public_ig_route" {
  route_table_id         = aws_route_table.Public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.Private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}
