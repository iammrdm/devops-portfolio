#!/bin/bash
set -xe
source ~/.bash_profile


apiInstanceID=${1}

cat /home/ec2-user/apiPublicIp.txt > /home/ec2-user/old-apiPublicIp.txt

managementIP=`curl http://checkip.amazonaws.com`
apiOldIP=`cat /home/ec2-user/old-apiPublicIp.txt`
slack_webhook_url=`echo ${slack_webhook_url}`
getAPIPublicIPv4=`aws --region ap-southeast-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=instance-id,Values=${apiInstanceID}" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text`

echo "Management IP: ${managementIP}"
echo "API old IP: ${apiOldIP}"
echo "API new IP: ${getAPIPublicIPv4}"
echo ${getAPIPublicIPv4}  > /home/ec2-user/apiPublicIp.txt

sed -i "s/${apiOldIP}/${getAPIPublicIPv4}/g"  /etc/hosts

bash  /home/ec2-user/devops-portfolio/bash-scripts/slackNotify.sh frontend management ${managementIP}:8081 ${slack_webhook_url}

