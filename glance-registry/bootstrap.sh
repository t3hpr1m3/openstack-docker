#!/bin/bash

KEYSTONE_TOKEN=ddc06b242b0718b495c7
KEYSTONE_ENDPOINT=http://keystone:35357/v2.0

. /opt/openstack/functions.sh

#
# Check to see if the glance database even exists
#
mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db -e "USE glance" >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "The glance database already exists."
else
	echo "The glance database doesn't exists.  Creating..."
	mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db < /opt/glance-registry/bootstrap.sql
	if [ $? -ne 0 ]; then
		echo "Error bootstrapping the glance database."
		exit 1
	fi
fi

#
# Now, check to see if the schema has been built
#
RESULT=$(mysql -N -s -u root --password=${MYSQL_ROOT_PASSWORD} -h db glance -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'glance' AND table_name = 'migrate_version';")

if [ $? -eq 1 ]; then
	echo "MySQL ERROR. Fix it."
	exit 1
elif [ "$RESULT" -ne "1" ]; then
	echo "The glance database is missing the schema. Initializing..."
	su -s /bin/sh -c "glance-manage db_sync" glance
else
	echo "The glance database has already been configured."
fi

exit 0
