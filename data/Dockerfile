FROM ubuntu:trusty
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /var/lib/rabbitmq
RUN mkdir -p /var/lib/glance/images

VOLUME /var/lib/mysql
VOLUME /var/lib/rabbitmq
VOLUME /var/lib/glance/images/
VOLUME /var/log/apache2

ENTRYPOINT ["/usr/bin/tail", "-f", "/dev/null"]
