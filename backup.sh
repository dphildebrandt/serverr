#!/bin/bash

source .env

containers=`docker ps -f "label=backup.stop" --format {{.Names}} | sort`

docker stop $containers

rclone sync $DOCKER_DIR/app-data Dropbox:serverr-appdata \
    -L -P --log-level=NOTICE --log-file=$LOG_DIR/appdata.log

docker start $containers
