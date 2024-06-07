#!/bin/bash

source .env

containers=`docker ps -f "label=backup.stop" --format {{.Names}} | sort`

docker stop $containers

rclone sync $DOCKER_DIR/app-data Dropbox:serverr-appdata \
    -P --skip-links --log-level=NOTICE --log-file=$DOCKER_DIR/logs/appdata.log \
    --tpslimit 5 --tpslimit-burst 0

docker start $containers
