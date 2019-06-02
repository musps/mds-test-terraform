#!/bin/bash

######################################
# STEP 1 : Create config file.       #
######################################
mkdir /bin/config

cat <<"__EOF__" > /bin/config/config.json
{
  "server": {
    "host": "0.0.0.0",
    "port": "${app_port}"
  },
  "options": {
    "prefix": "Generated url : /"
  },
  "postgres": {
    "host": "${db_host}",
    "port": "${db_port}",
    "user": "${db_username}",
    "password": "${db_password}",
    "db": "${db_name}"
  }
}
__EOF__

######################################
# STEP 2 : Create ursho service.     #
######################################
cat <<"__EOF__" > /etc/systemd/system/ursho.service
[Unit]
Description=ursho service

[Service]
Type=simple
WorkingDirectory=/bin
ExecStart=/bin/ursho

[Install]
WantedBy=multi-user.target
__EOF__

######################################
# STEP 3 : Start ursho service.      #
######################################
systemctl daemon-reload
systemctl enable my-ursho.service
systemctl start ursho
