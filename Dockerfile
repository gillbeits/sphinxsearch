FROM centos:7

MAINTAINER Ivan Koretskiy, gillbeits@gmail.com

RUN rpm --quiet -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum --disablerepo=extras --disablerepo=updates install -y -q http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && \
    yum --disablerepo=extras --disablerepo=updates install -y -q wget vim tar cronie postgresql-libs initscripts unixODBC && \
    yum --disablerepo=extras --disablerepo=updates install -y -q Percona-Server-shared-56 Percona-Server-client-56 && \
    yum install -y gcc-c++ Percona-Server-devel-56 openssl-devel postgresql-devel unixODBC-devel make automake && \
    cd /tmp && wget https://github.com/sphinxsearch/sphinx/archive/master.tar.gz && tar xzf master.tar.gz && \
    cd /tmp/sphinx-master && ./configure --prefix=/usr --with-pgsql && make install && \
    useradd -d /var/lib/sphinx -s /bin/bash sphinx && \
    mkdir -p /var/run/sphinx && \
    yum remove -y -q gcc-c++ Percona-Server-devel-56 openssl-devel postgresql-devel unixODBC-devel make automake && \
    yum -y -q autoremove && \
    rm -rf /tmp/sphinx* master.tar.gz && \
    yum clean -y -q all

# expose ports
EXPOSE 9306 9312

RUN rm -rf /etc/sphinx
RUN rm -rf /var/spool/cron/sphinx

VOLUME ["/etc/sphinx", "/var/spool/cron", "/var/lib/sphinx", "/var/log/sphinx"]
 
ENTRYPOINT ["/entrypoint.sh"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["sphinx", "indexer"]
