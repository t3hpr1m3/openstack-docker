FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update && apt-get -y install \
		python-openstackclient \
		python-keystoneclient \
		python-glanceclient \
		mysql-client \
		rabbitmq-server \
		curl \
	&& apt-get clean

CMD ["/bin/bash"]
