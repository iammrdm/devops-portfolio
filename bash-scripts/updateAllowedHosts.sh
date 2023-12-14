#!/bin/bash

getIP=`curl http://checkip.amazonaws.com`

sed -i "s/change_me/${getIP}/g" /opt/pos-super-admin/api/settings.py