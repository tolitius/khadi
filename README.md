# khadi

> _"Khadi refers to handwoven cloth. Mahatma Gandhi started spinning himself and encouraging others to do so."_

## What is it?

`khadi` is a bash based cli for Gandi's [LiveDNS API](https://doc.livedns.gandi.net/)

## What can I do with it?

Anything that Gandi's LiveDNS API allows, but in short:

* manage DNS Zone templates that you can integrate into your own workflow
  - including updating `A` (ip address) or any other DNS records
* bulk record management
* association with multiple domains
* versioning
* rollback

`khadi` does not support all of it yet, but the support is added on demand: i.e. if you miss something, you are welcome to open an [issue](https://github.com/tolitius/khadi/issues) or sumbit a pull request.

## Setup `khadi`

In order to use Gandi's LiveDNS API, you have to create you API key [as described](https://doc.livedns.gandi.net/#step-1-get-your-api-key) in API's docs.

Once you have the key, create a `~/.khadi/config` file and paste your key there:

```bash
$ cat ~/.khadi/config
api_key=FxNoG7le4xPwn20b1h4x5Zsj
```

this will enable `khadi` to work with Gandi's API without asking for an API key. It is also a bit more secure than to have a trail of this key in the bash history.

## Creating a DNS zone template

In order to create a zone template have your domain name ready (let's say it is "example.com"):

```bash
$ ./create-zone.sh example.com

...
{"message": "Zone Created", "uuid": "d019a4c1-0627-4b2d-9efb-ad182679eab7"}
```

this step might be automated later, but before it is add this zone uuid prefixed with `zone_` to your `~/.khadi/config`:

```bash
$ echo zone_examplecom=d019a4c1-0627-4b2d-9efb-ad182679eab7 >> ~/.khadi/config
```

notice to exclude the `.` in the domain name key: i.e. example.com => `examplecom`

```bash
$ cat ~/.khadi/config
api_key=FxNoG7le4xPwn20b1h4x5Zsj
zone_examplecom=d019a4c1-0627-4b2d-9efb-ad182679eab7
```

at this point this zone template can be referenced by the domain name:

```bash
$ ./do-whatever-dns-command-that-uses-this-zone example.com
```

## Link zone template to domain

In order for DNS records of the zone template to be connected to a domain name, zone uuid and domain name should be associated/linked.

You can link them by:

```bash
$ ./link-to-domain.sh example.com
HTTP/1.1 201 Created
...
Location: https://dns.api.gandi.net/api/v5/domains/example.com

{"message": "Domain Created"}
```

`khadi` picked up the zone uuid from the `~/.khadi/config` file to link it to example.com.

Now it is time to "live" update these juicy DNS records.

## Update domain's IP address

This example will update 3 DNS `A` recrods with an IP address of the box it is running on.

These 3 DNS records will be updated:

```bash
www IN A $ip_address
*   IN A $ip_address
@   IN A $ip_address
```

The reason for this script to be that specific is the quite frequent need to update an IP address of the domain:

* domain points to a "hosting solution" service / server that is running with a dynamic IP
* domain points to a home server / service where ISP changes IP address randomly

In order to update the IP address:

```bash
$ ./update-ip-address.sh example.com
updating DNS records for example.com to 98.118.10.32 ip address...
HTTP/1.1 201 Created
...
Location: https://dns.api.gandi.net/api/v5/zones/d019a4c1-0627-4b2d-9efb-ad182679eab7/records
...
{"message": "DNS Zone Record Created"}
```

notice `khadi` used the zone uuid that we created earlier.

At this point this update script can be `cron`'ed / scheduled to run on the server with a dynamic IP address periodically to make sure Gandi always has the latest IP address for this domain.

## Check domain DNS records

Besides logging in to the Gandi's dashboard and checking records there, they can be checked from command line with `./check-records.sh`:

```bash
$ ./check-records.sh example.com
```
```json
[
  {
    "rrset_type": "A",
    "rrset_ttl": 10800,
    "rrset_name": "*",
    "rrset_href": "https://dns.api.gandi.net/api/v5/zones/d019a4c1-0627-4b2d-9efb-ad182679eab7/records/%2A/A",
    "rrset_values": [
      "98.118.10.32"
    ]
  },
  {
    "rrset_type": "A",
    "rrset_ttl": 10800,
    "rrset_name": "@",
    "rrset_href": "https://dns.api.gandi.net/api/v5/zones/d019a4c1-0627-4b2d-9efb-ad182679eab7/records/%40/A",
    "rrset_values": [
      "98.118.10.32"
    ]
  },
  {
    "rrset_type": "A",
    "rrset_ttl": 10800,
    "rrset_name": "www",
    "rrset_href": "https://dns.api.gandi.net/api/v5/zones/d019a4c1-0627-4b2d-9efb-ad182679eab7/records/www/A",
    "rrset_values": [
      "98.118.10.32"
    ]
  }
]
```

noice!

## License

Copyright © 2018 tolitius

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
