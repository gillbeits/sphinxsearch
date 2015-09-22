FROM centos:7

MAINTAINER Ivan Koretskiy, gillbeits@gmail.com

#add EPEL Repository
RUN rpm --quiet -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum --disablerepo=extras --disablerepo=updates install -y -q http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && \
    yum --disablerepo=extras --disablerepo=updates install -y -q wget vim tar cronie postgresql-libs initscripts unixODBC && \
    yum --disablerepo=extras --disablerepo=updates install -y -q Percona-Server-shared-56 Percona-Server-client-56 && \
    rpm --quiet -Uhv http://sphinxsearch.com/files/sphinx-2.2.10-1.rhel7.x86_64.rpm && \
    yum clean -y -q all

RUN wget http://sphinxsearch.com/files/dicts/ru.pak -P /var/lib/sphinx/_dict
RUN wget http://sphinxsearch.com/files/dicts/en.pak -P /var/lib/sphinx/_dict
RUN wget http://sphinxsearch.com/files/dicts/de.pak -P /var/lib/sphinx/_dict


RUN localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 && \
    localedef -i de_DE -f UTF-8 de_DE.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# expose ports
EXPOSE 9306 9312

RUN rm -rf /etc/sphinx
RUN rm -rf /var/spool/cron/sphinx

VOLUME ["/etc/sphinx", "/var/spool/cron", "/var/lib/sphinx", "/var/log/sphinx"]
 
ENTRYPOINT ["/entrypoint.sh"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["sphinx", "indexer"]
