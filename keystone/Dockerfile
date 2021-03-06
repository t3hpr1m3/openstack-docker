FROM openstack/base

RUN apt-get -y install \
		keystone \
		python-keystoneclient \
		python-mysqldb \
		mysql-client \
		apache2 \
		libapache2-mod-wsgi \
	&& apt-get clean

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

RUN mkdir /opt/keystone

COPY wsgi-keystone.conf /etc/apache2/sites-available/

RUN a2ensite wsgi-keystone
RUN mkdir -p /var/www/cgi-bin/keystone/ && curl \
	http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
	| tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin && \
	chown -R keystone:keystone /var/www/cgi-bin/keystone && \
	chmod 755 /var/www/cgi-bin/keystone/*
RUN rm -f /var/lib/keystone/keystone.db

COPY keystone.conf /etc/keystone/

COPY bootstrap.sql /opt/keystone/
COPY bootstrap.sh /opt/keystone/
COPY init.sh /opt/keystone/

EXPOSE 5000
EXPOSE 35357

CMD ["/opt/keystone/init.sh"]
