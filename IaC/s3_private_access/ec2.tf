data "aws_ami" "amazonlinuximage" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#### Instance provisioning in Public subnet ####
resource "aws_instance" "public_vm" {
  for_each               = { for key, value in aws_subnet.public_subnet : key => value }
  ami                    = data.aws_ami.amazonlinuximage.id
  instance_type          = "t2.micro"
  key_name               = "admin"
  subnet_id              = aws_subnet.public_subnet[each.key].id
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  user_data              = file("tomcat_install.sh")
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("admin.pem")
    host        = self.public_ip
  }
  tags = merge(var.common_tags, { Name = "Public_VM" })
}

#### Instance provisioning in Private subnet ####
resource "aws_instance" "private_vm" {
  for_each               = { for key, value in aws_subnet.private_subnet : key => value }
  ami                    = data.aws_ami.amazonlinuximage.id
  instance_type          = "t2.micro"
  key_name               = "admin"
  subnet_id              = aws_subnet.private_subnet[each.key].id
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  iam_instance_profile   = aws_iam_instance_profile.demo_profile.name
  tags                   = merge(var.common_tags, { Name = "Private_VM" })
}
