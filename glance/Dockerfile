FROM openstack/base

RUN apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		glance \
	&& apt-get clean

RUN mkdir /opt/glance-registry
# COPY glance/glance-api.conf /etc/glance/
COPY glance/glance-registry.conf /etc/glance/

EXPOSE 9292

CMD ["/opt/openstack/init"]
