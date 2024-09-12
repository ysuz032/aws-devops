#!/bin/bash

echo daemon-reload
systemctl daemon-reload

echo start app.service
systemctl start app.service
