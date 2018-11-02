#!/bin/bash

. ~/.khadi/config --source-only

## takes domain id (i.e. "google"), checks whether
##  * it is present (in a var)
##  * it has a .suffix (i.e. foo.suffix)
validate_domain() {

     domain=$1

     if [[ -z $domain ]]
     then
          echo "missing domain"
          echo "usage: $0 domain"
          exit 1
     elif [[ "$domain" == "${domain/.}" ]]
     then
          echo "$domain is not a valid FQDN"
          echo "usage: $0 valid-FQDN-domain-name"
          echo "i.e. : $0 dotkam.com"
          exit 1
     fi
}

## takes domain id (i.e. "google"), checks whether zone entry exists in config
check_zone() {

     zone_var=$(echo zone_${1/.})
     zoned=${!zone_var}

     if [[ -z $zoned ]]
     then
          echo 'missing zone id: i.e. no "zone_'${1/.}'" entry in "~/.khadi/config" for "'$1'" domain.'
          exit 1
     fi
}

find_zone() {
     zone_var=$(echo zone_${1/.})
     echo ${!zone_var}
}

## checks whether gandi api key exists in config
check_api_key() {

     if [[ -z $api_key ]]
     then
          echo missing gandi API key: i.e. no "api_key" entry in "~/.khadi/config"
          exit 1
     fi
}

## given an ip finder (i.e. "ifconfig.co") looks up an IPv4 address
lookup_ip_address() {

     ip_finder=$1
     ip_address=`curl -4s $ip_finder`

     if [[ $ip_address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
          echo $ip_address
     else
          echo could not find a valid ip address from $ip_finder >&2
          echo "(ip address found: [$ip_address])" >&2
          exit 1
     fi
}
