#!/bin/bash

source ~/.bash_profile

getIP=`curl http://checkip.amazonaws.com`
slack_webhook_url=`echo ${slack_webhook_url}`

echo -e "[INFO] Current IP: ${getIP}"
echo -e "[INFO] ${slack_webhook_url}"


sed -i "s/change_me/${getIP}/g" /opt/pos-super-admin/api/settings.py

bash /opt/devops-portfolio/bash-scripts/slackNotify.sh pos ${getIP}:8000 ${slack_webhook_url}