#!/bin/bash

# : "${KHADI_HOME:?is not set. set it to point to $( cd "$(dirname "$0")" ; pwd -P )}"
KHADI_HOME=$( cd "$(dirname "$0")" ; pwd -P )

. $KHADI_HOME/tools.sh

domain=$1

validate_domain $domain
check_zone $domain
check_api_key

curl -sH "X-Api-Key: $api_key" \
     https://dns.api.gandi.net/api/v5/zones/$(find_zone $domain)/records
