FROM centos

MAINTAINER Ivan Koretskiy, gillbeits@gmail.com

#add EPEL Repository
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y -q http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm

# install utils
RUN yum install -y wget vim tar cronie postgresql-libs initscripts unixODBC
RUN yum install -y Percona-Server-shared-56

#install sphinxsearch 
RUN rpm -Uhv http://sphinxsearch.com/files/sphinx-2.2.7-1.rhel7.x86_64.rpm 

# expose ports
EXPOSE 9306 9312

ADD time_to_log.sh /
RUN chmod +x /time_to_log.sh

RUN mkdir -p /var/lock/subsys

RUN rm -rf /etc/sphinx
RUN rm -rf /var/spool/cron/sphinx

VOLUME ["/etc/sphinx", "/var/spool/cron", "/var/lib/sphinx", "/var/log/sphinx"]
 
ENTRYPOINT ["/entrypoint.sh"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["sphinx", "indexer"]

