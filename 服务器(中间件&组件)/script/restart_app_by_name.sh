#!/bin/sh


echo "[INFO] Start application in develop mode."
cd `dirname $0`
DEPLOY_DIR=`pwd`
echo "[INFO] DEPLOY_DIR: The $DEPLOY_DIR !"
echo "[INFO] DEPLOY_APP: The $1 !"

	SERVER_NAME=$1
	
	PIDS=`ps --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" |awk '{print $2}'`

	if [ -n "$PIDS" ]; then
		echo "[INFO] ERROR: The $SERVER_NAME already started!"
		echo "[INFO] PID: $PIDS"
	#    exit 1
		echo -e "[INFO] Stopping the $SERVER_NAME ...\c"
		for PID in $PIDS ; do
			kill -9  $PID > /dev/null 2>&1
		done

		COUNT=0
		while [ $COUNT -lt 1 ]; do
			echo -e ".\c"
			sleep 1
			COUNT=1
			for PID in $PIDS ; do
				PID_EXIST=`ps --no-heading -p $PID`
					if [ -n "$PID_EXIST" ]; then
						COUNT=0
						break
					fi
			done
		done
		echo "[INFO] OK!"
	fi

	LOGS_DIR=""
	LOGS_DIR=${DEPLOY_DIR}/logs

	if [ ! -d ${LOGS_DIR} ]; then
			mkdir ${LOGS_DIR}
	fi
	STDOUT_FILE=${LOGS_DIR}/stdout_${SERVER_NAME}.log
	STDOUT_LAST_FILE=${LOGS_DIR}/stdout_${SERVER_NAME}.last

	#rm -fr ${STDOUT_FILE} ${STDOUT_LAST_FILE}
	mv ${STDOUT_FILE} ${STDOUT_LAST_FILE}

	echo -e "[INFO] Starting the $SERVER_NAME ...\c\r\n"

	JAVA_OPTS="-server -Xmx512m -XX:MetaspaceSize=218m -Djava.security.egd=file:/dev/./urandom"

	nohup java ${JAVA_OPTS} -jar ${SERVER_NAME} > ${STDOUT_FILE} 2>&1 &

	COUNT=0
	while [ ${COUNT} -lt 1 ]; do
		echo -e ".\c"
		sleep 1
			COUNT=`ps  --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" | awk '{print $2}' | wc -l`
			if [ ${COUNT} -gt 0 ]; then
					break
			fi
	done
	echo "[INFO] OK!"
	PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" | awk '{print $2}'`
	echo "[INFO] PID: $PIDS"
	echo "[INFO] STDOUT: $STDOUT_FILE"









