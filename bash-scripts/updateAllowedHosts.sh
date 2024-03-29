#!/bin/bash

source ~/.bash_profile


cat /home/ec2-user/publicIP.txt > /home/ec2-user/oldIP.txt

getIP=`curl http://checkip.amazonaws.com`
oldIP=`cat /home/ec2-user/oldIP.txt`
slack_webhook_url=`echo ${slack_webhook_url}`

echo -e "[INFO] Current IP: ${getIP}"
echo -e "[INFO] Old IP: ${oldIP}"

echo ${getIP} > /home/ec2-user/publicIP.txt

sed -i "s/${oldIP}/${getIP}/g"  /home/ec2-user/pos-super-admin/api/settings.py
sed -i "s/change_me/${getIP}/g"  /home/ec2-user/pos-super-admin/api/settings.py

bash  /home/ec2-user/devops-portfolio/bash-scripts/runPythonBackground.sh
sleep 5

bash  /home/ec2-user/devops-portfolio/bash-scripts/slackNotify.sh backend pos ${getIP}:8000 ${slack_webhook_url}
