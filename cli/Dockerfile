FROM openstack/base

RUN apt-get -y install \
		python-openstackclient \
		python-keystoneclient \
		python-glanceclient \
		python-novaclient \
		mysql-client \
		rabbitmq-server \
		vim \
	&& apt-get clean

COPY admin-openrc.sh /admin-openrc.sh

CMD ["/bin/bash"]
