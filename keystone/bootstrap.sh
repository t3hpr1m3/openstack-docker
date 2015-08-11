#!/bin/bash

KEYSTONE_ENDPOINT=http://keystone:35357/v2.0
KEYSTONE_TOKEN=ddc06b242b0718b495c7

. /opt/openstack/functions.sh

#
# Check to see if the keystone database even exists
#
mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db -e "USE keystone" >/dev/null 2>&1
if [ "$?" -eq "0" ]; then
	echo "The keystone database already exists."
else
	echo "The keystone database doesn't exists.  Creating..."
	mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db < /opt/keystone/bootstrap.sql
	if [ $? -ne 0 ]; then
		echo "Error bootstrapping the keystone database."
		exit 1
	fi
fi

#
# Now, check to see if the schema has been built
#
RESULT=$(mysql -N -s -u root --password=${MYSQL_ROOT_PASSWORD} -h db keystone -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'keystone' AND table_name = 'migrate_version';")

if [ $? -eq 1 ]; then
	echo "MySQL Error. Fix it."
	exit
elif [ "$RESULT" -ne "1" ]; then
	echo "The keystone database is missing the schema.  Initializing..."
	su -s /bin/sh -c "keystone-manage db_sync" keystone
else
	echo "The keystone database has already been configured"
fi

/usr/sbin/apachectl -k start
sleep 5
create_service "keystone" "OpenStack Identity" "identity"
create_endpoint \
	"http://keystone:5000/v2.0" \
	"http://keystone:5000/v2.0" \
	"http://keystone:35357/v2.0" \
	"keystone"
create_tenant \
	"admin" \
	"Admin Project"
create_role \
	"admin"
create_user \
	"admin" \
	"firma8isdead"
add_role_to_user \
	"admin" \
	"admin" \
	"admin"
create_tenant \
	"service" \
	"Service Project"

/usr/sbin/apachectl -k stop
sleep 5
