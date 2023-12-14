#!/bin/bash

/usr/bin/python3  /home/ec2-user/pos-super-admin/manage.py makemigrations > /var/log/makemigrations.log
sleep 5
/usr/bin/python3  /home/ec2-user/pos-super-admin/manage.py migrate > /var/log/migrate.log
sleep 5
nohup /usr/bin/python3  /home/ec2-user/pos-super-admin/manage.py runserver 0.0.0.0:8000 > /var/log/pos.log &