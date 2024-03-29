#!/bin/bash
set -xe
source ~/.bash_profile


apiInstanceID=${1}

cat /home/ec2-user/apiPublicIp.txt > /home/ec2-user/old-apiPublicIp.txt

managementIP=`curl http://checkip.amazonaws.com`
apiOldIP=`cat /home/ec2-user/old-apiPublicIp.txt`
slack_webhook_url=`echo ${slack_webhook_url}`
getAPIPublicIPv4=`aws --region ap-southeast-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=instance-id,Values=${apiInstanceID}" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text`

cd /home/ec2-user/pos-management && git reset --hard && git pull
sleep 5

echo "Management IP: ${managementIP}"
echo "API old IP: ${apiOldIP}"
echo "API new IP: ${getAPIPublicIPv4}"
echo ${getAPIPublicIPv4}  > /home/ec2-user/apiPublicIp.txt

sed -i "s/${apiOldIP}/${getAPIPublicIPv4}/g"  /etc/hosts
sed -i "s/localhost/${getAPIPublicIPv4}/g"  /home/ec2-user/pos-management/docker-compose.yaml
sleep 5

cd /home/ec2-user/pos-management && docker build -t iammrdm/laundry-pos:management-prod-latest .
sleep 5

docker-compose -f /home/ec2-user/pos-management/docker-compose.yaml up -d
sleep 5

bash  /home/ec2-user/devops-portfolio/bash-scripts/slackNotify.sh frontend management ${managementIP}:8081 ${slack_webhook_url}

