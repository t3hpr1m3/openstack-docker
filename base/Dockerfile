FROM ubuntu:trusty

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update && apt-get -y install \
		curl \
	&& apt-get clean

COPY functions.sh /opt/openstack/functions.sh
