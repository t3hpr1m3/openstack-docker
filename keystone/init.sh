#!/bin/bash

/opt/keystone/bootstrap.sh
. /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND
