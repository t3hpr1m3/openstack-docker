#!/bin/bash

/opt/glance-api/bootstrap.sh
exec /usr/bin/glance-api
