FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update && apt-get -y install \
		python-mysqldb \
		mysql-client \
		rabbitmq-server \
		memcached \
		python-memcache \
		apache2 \
		libapache2-mod-wsgi \
		supervisor \
		curl \
	&& apt-get clean

#
# Keystone
#
RUN apt-get -y install \
		keystone \
		python-keystoneclient \
	&& apt-get clean
COPY keystone/wsgi-keystone.conf /etc/apache2/sites-available/
COPY keystone/keystone.conf /etc/keystone/
COPY keystone/keystone.sql /keystone-init/

RUN a2ensite wsgi-keystone
RUN mkdir -p /var/www/cgi-bin/keystone/ && curl \
	http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
	| tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin && \
	chown -R keystone:keystone /var/www/cgi-bin/keystone && \
	chmod 755 /var/www/cgi-bin/keystone/*
RUN rm -f /var/lib/keystone/keystone.db

#
# Glance
#
RUN apt-get -y install \
		glance \
		python-glanceclient \
	&& apt-get clean
COPY glance/glance-api.conf /etc/glance/
COPY glance/glance-registry.conf /etc/glance/


COPY keystone-start.sh /keystone-init/
COPY bootstrap.sh /keystone-init/

EXPOSE 5000
EXPOSE 35357
EXPOSE 9292

CMD ["/openstack-start"]
