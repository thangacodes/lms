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
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
#!/bin/bash
# remove comment if you want to enable debugging
# set -x
echo -e "\e[1;32m ***** Going to install Apache Tomcat10 on Remote Servers *****" $(date '+%Y-%m-%d %H:%M:%S')
cd /tmp/
yum update -y
yum install -y wget
yum install -y java
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.tar.gz
aws s3 cp s3://gitops-demo-bucket-tf/Java_Build_Artifacts/lms.war .
ls -lart > files_in_temp.txt
tar -xf apache-tomcat-10.0.27.tar.gz
sleep 5
rm -rf apache-tomcat-10.0.27.tar.gz  #removing the tar.gz file, post downloads in /tmp directory
mkdir /opt/tomcat10  # Create a new directory under /opt
cd /opt/tomcat10/    # Change directory to the /tomcat10 
cp -R /tmp/apache-tomcat-10.0.27 .
cp -R /tmp/lms.war /opt/tomcat10/apache-tomcat-10.0.27/webapps/
cd /opt/tomcat10/apache-tomcat-10.0.27/bin/
sh startup.sh  #Tomcat service starting
sleep 10
ls -l /opt/tomcat10/apache-tomcat-10.0.27/webapps/ > /tmp/webapps_files.txt
cat /opt/tomcat10/apache-tomcat-10.0.27/logs/catalina.out > /tmp/tomcat_log.txt
EOF
  tags = {
    Name         = "${var.server_name}"
    Owner        = "Thangadurai.Murugan@example.com"
    CreationDate = "14/07/2023"
    Region       = "ap-south-1"
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.server_name}-WebServer-SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.server_name}_SecurityGroup"
    Owner        = "Thangadurai.Murugan@example.com"
    CreationDate = "14/07/2023"
    Region       = "ap-south-1"
  }
}
