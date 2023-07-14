#!/bin/bash
yum update -y
yum install -y wget
yum install -y java
cd /tmp/
pwd
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.11/bin/apache-tomcat-10.1.11.tar.gz .
sleep 10
aws s3 cp s3://gitops-demo-bucket-tf/lms.war .
ls -lart > files_in_temp.txt
tar -xf apache-tomcat-10.1.11.tar.gz
sleep 5
rm -rf apache-tomcat-10.0.27.tar.gz  #removing the tar.gz file, post downloads in /tmp directory
mkdir /opt/tomcat10  # Create a new directory under /opt
cd /opt/tomcat10/    # Change directory to the /tomcat10 
cp -R /tmp/apache-tomcat-10.1.11 .
cp -R /tmp/lms.war /opt/tomcat10/apache-tomcat-10.1.11/webapps/
cd /opt/tomcat10/apache-tomcat-10.1.11/bin/
sh startup.sh  #Tomcat service starting
sleep 10
ls -l /opt/tomcat10/apache-tomcat-10.1.11/webapps/ > /tmp/webapps_files.txt
cat /opt/tomcat10/apache-tomcat-10.1.11/logs/catalina.out > /tmp/tomcat_log.txt
