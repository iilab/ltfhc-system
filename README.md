ltfhc-system
============

System Configs and Scripts

The LTFHC system requires Ubuntu 13.10 to function properly. Install it from a USB stick built from this image: http://releases.ubuntu.com/13.10/ubuntu-13.10-server-amd64.iso

## Install packages

sudo apt-get install lm-sensors sensord uucp mgetty git traceroute collectd-utils dnsmasq dnsmasq-utils hostapd iw python-dev python-pip python-django nginx openvpn python-uwsgicc ifplugd

## Enable TRIM

 - Add `'issue_discards = 1'` to `/etc/lvm/lvm.conf`
 - Add cron job to `/etc/cron.daily`

## Install python modules

 - pip install minimalmodbus

## Change hostname

 - Edit `/etc/hosts` and change the hostname to the site name where the box will be installed.
 - Edit `/etc/hostname` and change the hostname to the site name where the box will be installed.

## Update UUCP Configurations

If this is a new system, `etc/uucp/sys` and `etc/uucp/call` must be edited (and changes committed) to add the new host's information. These files will need to be pushed out to each system that needs to contact this box over uucp (by uucp'ing the files to those systems).

## Mobile Internet

 - These configurations will automatically start a mobile internet connection on the airtel network (see `etc/init/airtel.conf`) if it is available.
 - If you do not need this functionality, please disable it by removing (or not installing) `etc/init/airtel.conf`.

## Add openvpn client keys

If this system is going to have direct Internet access, a new key will need to be generated on the OpenVPN server. 

 - SSH to `ltfhc-prod.hact.net`
 - `sudo su -`
 - `cd /etc/openvpn/easy-rsa`
 - `source ./vars`
 - `pkitool <sitename>` 
 - Example:
```
root@ltfhc-prod:/etc/openvpn/easy-rsa# source ./vars
NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/easy-rsa/keys
root@ltfhc-prod:/etc/openvpn/easy-rsa# ./pkitool test
Using Common Name: ltfhc-dev
Generating a 1024 bit RSA private key
.........++++++
.........................++++++
writing new private key to 'test.key'
-----
Using configuration from /etc/openvpn/easy-rsa/openssl-1.0.0.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'US'
stateOrProvinceName   :PRINTABLE:'NC'
localityName          :PRINTABLE:'Durham'
organizationName      :PRINTABLE:'iilab'
organizationalUnitName:PRINTABLE:'LTFHC'
commonName            :PRINTABLE:'ltfhc-dev'
name                  :PRINTABLE:'changeme'
emailAddress          :IA5STRING:'tech@iilab.org'
Certificate is to be certified until Mar 21 00:34:58 2024 GMT (3650 days)

Write out database with 1 new entries
Data Base Updated
```

 - Copy the files `/etc/openvpn/easy-rsa/keys/<sitename>.key`, `/etc/openvpn/easy-rsa/keys/<sitename>.crt`, `/etc/openvpn/ca.crt`, and `/etc/openvpn/ta.key` to the new machine's `/etc/openvpn` directory.
 - Edit `/etc/openvpn/client.conf` on the new machine and change `<CLIENT SPECIFIC>` to match the names you put in.

## Copy configurations

The `etc` directory in this repository contains all of the configuration required to bootstrap a system. Copy all of the files herein into their mirroring locations in the filesystem. 

## Run LTFHC deployment script

 - `cd` into the `scripts` directory of this respository. 
 - Run `./deploy.sh`. This script will download all of the dependencies and a code bundle from Google Storage.
 - Follow the instructions in the `ltfhc-next/docs/USB_install_instructions.md` file under `Testing the System` to test the application.

## Reboot the system and test again.

Make sure that all application and system daemons start up:

 - nginx
 - couchdb
 - collectd
 - openvpn (if needed)
 - ppp (if mobile Internet connection needed)
 - mgetty (on ttyS0)

Run through the application tests once more to make sure something didn't break after the reboot. 
