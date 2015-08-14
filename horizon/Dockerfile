FROM openstack/base

RUN apt-get -y --no-install-recommends install \
		apache2 \
		openstack-dashboard \
	&& apt-get clean

RUN mkdir /opt/horizon/

COPY init.sh /opt/horizon/

COPY local_settings.py /etc/openstack-dashboard/

EXPOSE 80

CMD ["/opt/horizon/init.sh"]
