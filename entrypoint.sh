#!/bin/bash

set -e

if [ "$1" = 'sphinx' ]; then
	trap "echo TRAPed signal" HUP INT QUIT KILL TERM

	chown -R sphinx:sphinx /var/lib/sphinx /var/log/sphinx
	echo "Start Cron Daemon"
	/usr/sbin/crond -n -x misc 2>&1 | /time_to_log.sh >> /var/log/sphinx/cron &
	if [ "$2" = 'indexer' ]; then
		echo "Start Sphinxsearch Indexer for --all indexes"
		su - sphinx -c '/usr/bin/indexer --all'
	fi

	echo "Starting Sphinx"
	service searchd start
	
	echo "[hit enter key to exit] or run 'docker stop <container>'"
	read

	echo "Stopping Sphinx"
	service searchd stop

elif [ "$1" = 'log' ]; then
	tail -f /var/log/sphinx/*
fi

exec "$@"

