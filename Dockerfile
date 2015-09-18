FROM centos

MAINTAINER Ivan Koretskiy, gillbeits@gmail.com

#add EPEL Repository
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y -q http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm

# install utils
RUN yum install -y wget vim tar cronie postgresql-libs initscripts unixODBC
RUN yum install -y Percona-Server-shared-56 Percona-Server-client-56

# install make packages
RUN yum install -y gcc-c++ Percona-Server-devel-56 openssl-devel postgresql-devel unixODBC-devel make automake

#install sphinxsearch 
RUN cd /tmp && wget https://github.com/sphinxsearch/sphinx/archive/master.tar.gz && tar xzf master.tar.gz
RUN cd /tmp/sphinx-master && ./configure --prefix=/usr --with-pgsql && make install
RUN useradd -d /var/lib/sphinx -s /bin/bash sphinx
RUN mkdir -p /var/run/sphinx

# uninstall make packages
RUN yum remove -y gcc-c++ Percona-Server-devel-56 openssl-devel postgresql-devel unixODBC-devel make automake
RUN yum -y autoremove
RUN rm -rf /tmp/sphinx* master.tar.gz

# expose ports
EXPOSE 9306 9312

RUN rm -rf /etc/sphinx
RUN rm -rf /var/spool/cron/sphinx

VOLUME ["/etc/sphinx", "/var/spool/cron", "/var/lib/sphinx", "/var/log/sphinx"]
 
ENTRYPOINT ["/entrypoint.sh"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["sphinx", "indexer"]
