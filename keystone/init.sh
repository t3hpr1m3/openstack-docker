#!/bin/bash

KEYSTONE_HOST=controller
KEYSTONE_TOKEN=ddc06b242b0718b495c7

#
# Check to see if the keystone database even exists
#
mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db -e "USE keystone" 2>&1 > /dev/null
if [ "$?" -eq "0" ]; then
	echo "The keystone database already exists."
else
	echo "The keystone database doesn't exists.  Creating..."
	mysql -u root --password=${MYSQL_ROOT_PASSWORD} -h db < /opt/openstack/keystone/init.sql
fi

#
# Now, check to see if the schema has been built
#
RESULT=$(mysql -N -s -u root --password=${MYSQL_ROOT_PASSWORD} -h db keystone -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'keystone' AND table_name = 'migrate_version';")
EXIT=$?

if [ "$EXIT" -eq "1" ]; then
	echo "MySQL Error. Fix it."
	exit
elif [ "$RESULT" -ne "1" ]; then
	echo "The keystone database is missing the schema.  Initializing..."
	su -s /bin/sh -c "keystone-manage db_sync" keystone
else
	echo "The keystone database has already been configured"
fi

#
# Finally, check to see if all the keystone stuffs exist
#
/usr/sbin/apachectl -k start
sleep 5
RESULT=$(keystone --os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 --os-token ${KEYSTONE_TOKEN} service-list | grep http://${KEYSTONE_HOST}:35357 | wc -l)
if [ $RESULT -ne 1 ]; then
	echo "Keystone not configured.  Initializing..."
	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		tenant-create \ --description "Admin Project"  \
		--name admin

	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		tenant-create \
		--description "Service Project" \
		--name service

	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		user-create \
		--pass firma8isdead \
		--name admin

	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		role-create \
		--name admin

	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		user-role-add \
		--tenant admin \
		--user admin \
		--role admin

	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		service-create \
		--name keystone \
		--description "OpenStack Identity" \
		--type identity


	keystone \
		--os-endpoint http://${KEYSTONE_HOST}:35357/v2.0 \
		--os-token ${KEYSTONE_TOKEN} \
		endpoint-create \
		--publicurl http://${KEYSTONE_HOST}:5000/v2.0 \
		--internalurl http://${KEYSTONE_HOST}:5000/v2.0 \
		--adminurl http://${KEYSTONE_HOST}:35357/v2.0 \
		--region RegionOne \
		--service keystone
else
	echo "Keystone already initialized."
fi
/usr/sbin/apachectl -k stop
sleep 5
