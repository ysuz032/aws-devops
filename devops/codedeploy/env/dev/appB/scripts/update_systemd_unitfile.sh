#!/bin/bash

# systemd の ユニットファイルを再配置する
APP_UNITFILE='/etc/systemd/system/app.service'
APP_ENV='/usr/local/etc/app.env'
APP_DIR='/usr/local/app'

# app.service
cat << EOF > $APP_UNITFILE
[Unit]
Description=app.service daemon
After=network.target

[Service]
EnvironmentFile=$APP_ENV
ExecStart=$APP_DIR/app
WorkingDirectory=$APP_DIR
Restart=always
Type=simple
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF