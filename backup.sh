#!/bin/bash

source .env

containers=`docker ps -f "label=backup.stop" --format {{.Names}} | sort`

for c in ${containers[@]}; do
    skipFiles=`docker ps -f "name=$c" --format '{{.Label "backup.skip"}}'`

    docker stop $c

    rclone sync $DOCKER_DATA_DIR/$c Dropbox:serverr-appdata/$c \
        -L -P --log-level=NOTICE --log-file=$LOG_DIR/appdata.log \
        --exclude=$skipFiles

    docker start $c
done
