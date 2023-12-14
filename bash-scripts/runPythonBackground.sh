#!/bin/bash

/usr/bin/python3hon3 /opt/pos-super-admin/manage.py makemigrations
sleep 5
/usr/bin/python3 /opt/pos-super-admin/manage.py migrate
sleep 5
nohup /usr/bin/python3 /opt/pos-super-admin/manage.py runserver 0.0.0.0:8000 > /var/log/api.log &