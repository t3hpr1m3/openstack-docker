FROM openstack/base

RUN apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		glance \
	&& apt-get clean

COPY glance-registry.conf /etc/glance/

RUN mkdir /opt/glance-registry
COPY bootstrap.sql /opt/glance-registry/
COPY bootstrap.sh /opt/glance-registry/
COPY init.sh /opt/glance-registry/

EXPOSE 9292

CMD ["/opt/glance-registry/init.sh"]
