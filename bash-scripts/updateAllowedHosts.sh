#!/bin/bash

source ~/.bash_profile



getIP=`curl http://checkip.amazonaws.com`
oldIP=`cat /tmp/oldIP.txt`
slack_webhook_url=`echo ${slack_webhook_url}`

cat /tmp/publicIP.txt > /tmp/oldIP.txt

echo -e "[INFO] Current IP: ${getIP}"
echo -e "[INFO] Old IP: ${oldIP}"

echo ${getIP} > /tmp/publicIP.txt

sed -i "s/${oldIP}/${getIP}/g"  /home/ec2-user/pos-super-admin/api/settings.py

bash  /home/ec2-user/devops-portfolio/bash-scripts/runPythonBackground.sh
sleep 5

bash  /home/ec2-user/devops-portfolio/bash-scripts/slackNotify.sh pos ${getIP}:8000 ${slack_webhook_url}
