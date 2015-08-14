#!/bin/bash

#
# Try to sub out the ip in nova.conf
#
addr=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')
sed -i -e "s|my_ip\ =.*|my_ip\ = ${addr}|" /etc/nova/nova.conf


exit 0
