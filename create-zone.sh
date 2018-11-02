#!/bin/bash

# : "${KHADI_HOME:?is not set. set it to point to $( cd "$(dirname "$0")" ; pwd -P )}"
KHADI_HOME=$( cd "$(dirname "$0")" ; pwd -P )

. $KHADI_HOME/tools.sh

domain=$1

validate_domain $domain
check_api_key

curl -sD- -X POST -H "Content-Type: application/json" \
             -H "X-Api-Key: $api_key" \
             -d '{"name": "'$domain' Zone"}' \
             https://dns.api.gandi.net/api/v5/zones

## {"message": "Zone Created", "uuid": "a7e251c4-1191-22e3-e522-a0141ef91042"}
