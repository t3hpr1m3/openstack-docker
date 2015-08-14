FROM openstack/base

RUN apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		nova-compute \
		sysfsutils \
		supervisor \
	&& apt-get clean

RUN mkdir /opt/nova-node/
COPY nova.conf /etc/nova/
RUN chown nova: /etc/nova/nova.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY bootstrap.sh /opt/nova-node/

CMD ["/usr/bin/supervisord"]
