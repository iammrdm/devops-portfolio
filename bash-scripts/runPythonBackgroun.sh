#!/bin/bash

python3 /opt/pos-super-admin/manage.py makemigrations
sleep 5
python3 /opt/pos-super-admin/manage.py migrate
sleep 5
nohup python3 /opt/pos-super-admin/manage.py runserver 0.0.0.0:8000 > /var/log/api.log &