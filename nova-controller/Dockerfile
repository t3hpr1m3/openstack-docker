FROM openstack/base

RUN apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		nova-api \
		nova-cert \
		nova-conductor \
		nova-consoleauth \
		nova-novncproxy \
		nova-scheduler \
		python-novaclient \
		supervisor \
	&& apt-get clean

RUN mkdir /opt/nova-server/
COPY nova.conf /etc/nova/
RUN chown nova: /etc/nova/nova.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY bootstrap.sh /opt/nova-server/
COPY bootstrap.sql /opt/nova-server/

EXPOSE 8774

CMD ["/usr/bin/supervisord"]
