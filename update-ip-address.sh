#!/bin/bash

# : "${KHADI_HOME:?is not set. set it to point to $( cd "$(dirname "$0")" ; pwd -P )}"
KHADI_HOME=$( cd "$(dirname "$0")" ; pwd -P )

. $KHADI_HOME/tools.sh

domain=$1

validate_domain $domain
check_zone $domain
check_api_key

ip_finder=ifconfig.co
ip_address=$(lookup_ip_address $ip_finder) || exit 1;

echo "updating DNS records for $domain to" $ip_address "ip address..."

curl -s -D- -XPUT -H "Content-Type: text/plain" \
    -H"X-Api-Key: $api_key" \
    --data-binary @- \
    https://dns.api.gandi.net/api/v5/zones/$(find_zone $domain)/records \
    << EOF
www IN A $ip_address
*   IN A $ip_address
@   IN A $ip_address
EOF
