#!/bin/bash
set -x
echo "***** Script execution at *****:" $(date '+%Y-%m-%d %H:%M:%S')
REQ_TOMCAT_VER="10.1.11"
echo ${REQ_TOMCAT_VER}
TOMCAT_MAJOR_VER=$(echo ${REQ_TOMCAT_VER} | cut -c1,2 )
echo ${TOMCAT_MAJOR_VER}
URL="https://dlcdn.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VER}/v${REQ_TOMCAT_VER}/bin/apache-tomcat-${REQ_TOMCAT_VER}.tar.gz"
echo ${URL}
# Configuring S3 bucket
S3_BUCKET="s3://gitops-demo-bucket-tf"
echo ${S3_BUCKET}
ARTIFACT="lms.war"
echo ${ARTIFACT}
echo "**** Setting up java in Tomcat server ****"
sudo yum install -y java
cd /tmp/
wget $URL
echo "***** Going to extract apache-tomcat-${REQ_TOMCAT_VER}.tar.gz *****"
tar -xf apache-tomcat-${REQ_TOMCAT_VER}.tar.gz
mv apache-tomcat-${REQ_TOMCAT_VER} tomcat${TOMCAT_MAJOR_VER}
ls -lrt
echo "**** No more tar.gz file is required. Removing it off from the current download path ****"
rm -rf apache-tomcat-${REQ_TOMCAT_VER}.tar.gz
ls -lrt
echo "**** Changing /opt/ directory... *****"
cd /opt/
pwd
sleep 5
echo "**** Recursively Copying tomcat${TOMCAT_MAJOR_VER}...****"
sudo cp -R /tmp/tomcat${TOMCAT_MAJOR_VER} .
ls -lrt
cd /opt/tomcat${TOMCAT_MAJOR_VER}/webapps/
pwd
echo "**** Downloading ${ARTIFACT} from bucket ${S3_BUCKET} ****"
aws s3 cp ${S3_BUCKET}/${ARTIFACT} .
sh ../bin/startup.sh
sleep 10
ls -l /opt/tomcat${TOMCAT_MAJOR_VER}/webapps/ > /tmp/webapps_files.txt
cat /opt/tomcat${TOMCAT_MAJOR_VER}/logs/catalina.out > /tmp/tomcat_log.txt
exit

