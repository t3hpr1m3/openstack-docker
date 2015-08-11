FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update && apt-get -y install \
		python-mysqldb \
		mysql-client \
		python-memcache \
		python-keystoneclient \
		glance \
		curl \
	&& apt-get clean

RUN mkdir /opt/glance-registry
# COPY glance/glance-api.conf /etc/glance/
COPY glance/glance-registry.conf /etc/glance/

EXPOSE 9292

CMD ["/opt/openstack/init"]
