#!/bin/bash

KEYSTONE_ENDPOINT=http://keystone:35357/v2.0
KEYSTONE_TOKEN=ddc06b242b0718b495c7

. /opt/openstack/functions.sh

#
# Check to see if the nova database even exists
#
mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db -e "USE nova" >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "The nova database already exists."
else
	echo "The nova database doesn't exists.  Creating..."
	mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db < /opt/nova-server/bootstrap.sql
	if [ $? -ne 0 ]; then
		echo "Error bootstrapping the nova database."
		exit 1
	fi
fi

#
# Now, check to see if the schema has been built
#
RESULT=$(mysql -N -s -u root --password=${MYSQL_ROOT_PASSWORD} -h db nova -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'nova' AND table_name = 'migrate_version';")

if [ $? -eq 1 ]; then
	echo "MySQL ERROR. Fix it."
	exit 1
elif [ "$RESULT" -ne "1" ]; then
	echo "The nova database is missing the schema. Initializing..."
	su -s /bin/sh -c "nova-manage db sync" nova
else
	echo "The nova database has already been configured."
fi

create_service \
	"nova" \
	"OpenStack compute" \
	"compute"
create_user \
	"nova" \
	"firma8isdead"
add_role_to_user \
	"nova" \
	"service" \
	"admin"
create_endpoint \
	"http://novacontroller:8774/v2/%(tenant_id)s" \
	"http://novacontroller:8774/v2/%(tenant_id)s" \
	"http://novacontroller:8774/v2/%(tenant_id)s" \
	"nova"

#
# Try to sub out the ip in nova.conf
#
addr=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')
sed -i -e "s|my_ip\ =.*|my_ip\ = ${addr}|" /etc/nova/nova.conf


exit 0
