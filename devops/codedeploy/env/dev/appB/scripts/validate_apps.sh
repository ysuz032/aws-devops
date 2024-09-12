#!/bin/bash

APP='/usr/local/app/app'

# wait 30sec for process start
sleep 30s

echo validate app process
pscount=$(ps aux | awk '{ print $11 }' | grep $APP | wc -l)
echo num of app process is $pscount


if [ $pscount != 1 ]; then
    echo app is not started 1>&2
    exit 1
fi