#!/bin/bash
set -e

function qDebug {
	if [ "${DEBUG}" = "y" || "${DEBUG}" = "YES" ] ; then
		return 0
	else
		return 1
	fi
}

qDebug && set -x

export LOGS_PATH="/var/log/mcompacter.log"

function die
{
	echo "ERROR: $1" | tee -a "${LOGS_PATH}" >&2
	exit 1
}

function log
{
	echo "$1" >> "${LOGS_PATH}"
}

function log_err
{
	echo "$1" | tee -a "${LOGS_PATH}" >&2
}

# -------------------------------------------------------------------
[ -n "$DATA_SOURCE" ] 	|| DATA_SOURCE="database"
[ -n "$HOST" ]   	|| HOST="localhost"
[ -n "$SSL" ]   	|| SSL="false"

if [ "$SSL" = "true" ] ; then
	SSL_COMMAND="--ssl"
else
	SSL_COMMAND=""
fi

if [ x$USERNAME = "x" ] && [ x$PASSWORD = "x" ];then
	mongo_command="mongo --host $HOST --quiet $SSL_COMMAND"
	mongodump_command="mongodump --quiet --host $HOST $SSL_COMMAND"
	mongoexport_command="mongoexport --quiet --host $HOST $SSL_COMMAND"
else
	mongo_command="mongo --quiet --host $HOST $SSL_COMMAND --authenticationDatabase admin -u $USERNAME -p $PASSWORD"
	mongodump_command="mongodump --quiet --host $HOST $SSL_COMMAND --authenticationDatabase admin -u $USERNAME -p $PASSWORD"
	mongoexport_command="mongoexport --quiet --host $HOST $SSL_COMMAND --authenticationDatabase admin -u $USERNAME -p $PASSWORD"
fi

