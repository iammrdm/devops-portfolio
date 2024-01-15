#!/bin/bash

cd /home/ec2-user/pos-super-admin
/usr/bin/python3  manage.py makemigrations > /var/log/makemigrations.log
sleep 5
/usr/bin/python3  manage.py migrate > /var/log/migrate.log
sleep 5
nohup /usr/bin/python3  manage.py runserver 0.0.0.0:8000 > /var/log/pos.log &
