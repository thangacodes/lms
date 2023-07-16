locals {
  vpc_tags = {
    Name = "DEV-ACCOUNT-VPC"
  }
  tags = merge(var.common_tags, local.vpc_tags)
}

locals {
  ec2_tags = {
    Name = "WEBNODE"
  }
  tagging = merge(var.common_tags, local.ec2_tags)
}

resource "aws_vpc" "testing" {
  cidr_block           = var.cidr_range
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.tags
}

locals {
  subnets = {
    "private_subnet_1" = { cidr_block = "192.168.1.0/24", availability_zone = "ap-south-1a", tag_name = "private_subnet_1a" }
    "private_subnet_2" = { cidr_block = "192.168.2.0/24", availability_zone = "ap-south-1b", tag_name = "private_subnet_1b" }
    "private_subnet_3" = { cidr_block = "192.168.3.0/24", availability_zone = "ap-south-1c", tag_name = "private_subnet_1c" }
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.testing.id
  for_each          = local.subnets
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.value.tag_name
  }
}

resource "aws_instance" "web" {
  ami                    = var.image_id
  instance_type          = var.ins_spec
  vpc_security_group_ids = var.security_group
  key_name               = var.ssh_key
  tags                   = local.tagging
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.testing.id
  tags   = merge(var.common_tags, { Name = "Internet_Gateway" })
}

locals {
  pub_subnet = {
    "public_subnet_1" = { cidr_block = "192.168.4.0/24", availability_zone = "ap-south-1a", tname = "public_subnet_1a" }
    "public_subnet_2" = { cidr_block = "192.168.5.0/24", availability_zone = "ap-south-1b", tname = "public_subnet_1b" }
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.testing.id
  for_each                = local.pub_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = each.value.tname
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.testing.id
  tags   = merge(var.common_tags, { Name = "Private_route_table" })
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.testing.id
  tags   = merge(var.common_tags, { Name = "Public_route_table" })
}

resource "aws_route" "public_ig_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each       = local.pub_subnet
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route.public_ig_route.id
}
