#!/bin/sh


echo "[INFO] Start application in develop mode."
cd `dirname $0`
DEPLOY_DIR=`pwd`
echo "[INFO] DEPLOY_DIR: The $DEPLOY_DIR !"
SERVER_NAME="java"

PIDS=`ps --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" |awk '{print $2}'`

if [ -n "$PIDS" ]; then
    echo "[INFO] ERROR: The $SERVER_NAME already started!"
    echo "[INFO] PID: $PIDS"
#    exit 1
    echo -e "[INFO] Stopping the $SERVER_NAME ...\c"
    for PID in $PIDS ; do
        kill -9 $PID > /dev/null 2>&1
    done
    echo "[INFO] ALL JAVA APP STOP OK!"
fi

