#!/bin/bash

KEYSTONE_TOKEN=ddc06b242b0718b495c7
KEYSTONE_ENDPOINT=http://keystone:35357/v2.0

. /opt/openstack/functions.sh

create_service \
	"glance" \
	"OpenStack Image service" \
	"image"
create_user \
	"glance" \
	"firma8isdead"
add_role_to_user \
	"glance" \
	"service" \
	"admin"
create_endpoint \
	"http://glance-api:9292" \
	"http://glance-api:9292" \
	"http://glance-api:9292"
