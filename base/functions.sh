#!/bin/bash

create_service () {
	if [ -z "$1" ]; then
		echo "Service name is required."
		return 1
	fi

	if [ -z "$2" ]; then
		echo "Service description is required."
		return 1
	fi

	if [ -z "$3" ]; then
		echo "Service type is required."
		return 1
	fi

	service_name=$1
	service_description=$2
	service_type=$3

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		service-list | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $3}' | \
		grep ${service_name} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing services."
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${service_name} service does not exist.  Creating..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			service-create \
			--name $service_name \
			--description "$service_desc" \
			--type $service_type

		if [ $? -ne 0 ]; then
			echo "Error creating $service_name service"
			return 1
		fi
	else
		echo "The $service_name service already exists."
		return 0
	fi
}

create_tenant () {
	if [ -z "$1" ]; then
		echo "Tenant name is required."
		return 1
	fi
	if [ -z "$2" ]; then
		echo "Tenant description is required."
		return 1
	fi

	tenant_name=$1
	tenant_desc=$2

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		tenant-list | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $3}' | \
		grep ${tenant_name} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing tenants."
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${tenant_name} tenant does not exist.  Creating..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			tenant-create \
			--description "$tenant_desc" \
			--name $tenant_name

		if [ $? -ne 0 ]; then
			echo "Error creating $tenant_name tenant."
			return 1
		fi
	else
		echo "The $tenant_name tenant already exists."
		return 0
	fi
}

create_endpoint () {
	if [ -z "$1" ]; then
		echo "public url is required."
		return 1
	fi

	if [ -z "$2" ]; then
		echo "internal url is required."
		return 1
	fi

	if [ -z "$3" ]; then
		echo "admin url is required."
		return 1
	fi

	if [ -z "$4" ]; then
		echo "endpoint type is required."
		return 1
	fi

	public_url=$1
	internal_url=$2
	admin_url=$3
	endpoint_type=$4

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		endpoint-list | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $4}' | \
		grep ${public_url} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing endpoints."
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${endpoint_type} endpoint does not exist.  Creating..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			endpoint-create \
			--service $endpoint_type \
			--region RegionOne \
			--publicurl $public_url \
			--internalurl $internal_url \
			--adminurl $admin_url \

		if [ $? -ne 0 ]; then
			echo "Error creating $endpoint_type endpoint."
			return 1
		fi
	else
		echo "The $endpoint_type endpoint already exists."
		return 0
	fi
}

create_role () {
	if [ -z "$1" ]; then
		echo "role name is required."
		return 1
	fi

	role_name=$1

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		role-list | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $3}' | \
		grep ${role_name} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing roles"
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${role_name} role does not exist.  Creating..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			role-create \
			--name $role_name

		if [ $? -ne 0 ]; then
			echo "Error creating $role role"
			return 1
		fi
	else
		echo "The $role_name role already exists."
		return 0
	fi
}

create_user () {
	if [ -z "$1" ]; then
		echo "username is required."
		return 1
	fi

	if [ -z "$2" ]; then
		echo "password is required."
		return 1
	fi

	username=$1
	password=$2

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		user-list | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $3}' | \
		grep ${username} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing users."
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${username} user does not exist.  Creating..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			user-create \
			--name $username \
			--pass $password

		if [ $? -ne 0 ]; then
			echo "Error creating $username user."
			return 1
		fi
	else
		echo "The $username user already exists."
		return 0
	fi
}

add_role_to_user () {
	if [ -z "$1" ]; then
		echo "username is required."
		return 1
	fi

	if [ -z "$2" ]; then
		echo "tenant is required."
		return 1
	fi

	if [ -z "$3" ]; then
		echo "role name is required."
		return 1
	fi

	username=$1
	tenant=$2
	role_name=$3

	RESULT=$(keystone \
		--os-endpoint $KEYSTONE_ENDPOINT \
		--os-token $KEYSTONE_TOKEN \
		user-role-list \
		--user $username \
		--tenant $tenant | \
		tail -n +4 | \
		head -n -1 | \
		awk -F \| '{print $3}' | \
		grep ${username} | \
		wc -l)

	if [ $? -ne 0 ]; then
		echo "Error listing roles for user $username"
		return 1
	elif [ $RESULT -ne 1 ]; then
		echo "The ${username} user does not have the $role_name role in tenant $tenant.  Adding..."
		keystone \
			--os-endpoint $KEYSTONE_ENDPOINT \
			--os-token $KEYSTONE_TOKEN \
			user-role-add \
			--user $username \
			--tenant $tenant \
			--role $role_name

		if [ $? -ne 0 ]; then
			echo "Error adding role $role_name to user $username in tenant ${tenant}."
			return 1
		fi
	else
		echo "The $username user already has the $role_name role in tenant ${tenant}."
		return 0
	fi
}


