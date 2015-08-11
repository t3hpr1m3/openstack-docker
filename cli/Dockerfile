FROM openstack/base

RUN apt-get -y install \
		python-openstackclient \
		python-keystoneclient \
		python-glanceclient \
		mysql-client \
		rabbitmq-server \
	&& apt-get clean

COPY admin-openrc.sh /admin-openrc.sh

CMD ["/bin/bash"]
