FROM openstack/base

RUN apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		glance \
	&& apt-get clean

RUN mkdir /opt/glance-api
COPY glance-api.conf /etc/glance/

COPY bootstrap.sh /opt/glance-api/
COPY init.sh /opt/glance-api/

EXPOSE 9191

CMD ["/opt/glance-api/init.sh"]
