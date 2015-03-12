#!/bin/bash

chown -R sphinx:sphinx /var/lib/sphinx /var/log/sphinx

/usr/sbin/crond -n -x misc 2>&1 | /time_to_log.sh >> /var/log/sphinx/cron &
if [ ! -f /etc/sphinx/indexer.true ]; then
	su - sphinx -c '/usr/bin/indexer --all'
	touch /etc/sphinx/indexer.true
fi

service searchd start

tail -f /var/log/sphinx/query.log /var/log/sphinx/searchd.log

