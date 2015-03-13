#Supported tags and respective ```Dockerfile``` links

- [```2.2.7`` `(Dockerfile)](https://github.com/gillbeits/sphinxsearch/blob/2.2.7/Dockerfile)
- [```2.2.8```, ```latest``` (Dockerfile)](https://github.com/gillbeits/sphinxsearch/blob/master/Dockerfile)

#How to use this image
## start adata container instance

	docker run --name sphinx-files -v /etc/sphinx -v /var/spool/cron -v /var/lib/sphinx -v /var/log/sphinx busybox true

## create config for sphinx

	docker run --rm -ti --volumes-from sphinx-files gillbeits/sphinxsearch editconfig

## run sphinx indexer (by default run indexer for all indexes)

	docker run --rm -ti --volumes-from sphinx-files --link postgres:postgres gillbeits/sphinxsearch indexer

## start a sphinx instance and connect it with ```sphinx-files``` data container and postgres/mysql container

	docker run --name sphinx -p 9306:9306 -p 9312:9312 --volumes-from sphinx-files --link postgres:postgres gillbeits/sphinxsearch sphinx

## for change crontab in ```sphinx``` container

	docker run --rm -ti --volumes-from sphinx-files gillbeits/sphinxsearch crontab
