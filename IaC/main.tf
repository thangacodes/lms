data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.server_size
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.demo_profile.name
  vpc_security_group_ids = [aws_security_group.web.id]
  tags                   = merge(var.taggy, { Name = "${var.server_name}-Server" })
}
resource "aws_security_group" "web" {
  name_prefix = "${var.server_name}-WebServer-SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.taggy, { Name = "${var.server_name}-SecurityGroup" })
}
