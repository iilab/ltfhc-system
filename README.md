ltfhc-system
============

System Configs and Scripts

Install packages:

sudo apt-get install lm-sensors sensord uucp mgetty git traceroute collectd-utils dnsmasq dnsmasq-utils hostapd iw python-dev python-pip python-django nginx openvpn python-uwsgicc ifplugd

Enable TRIM:

 - Add 'issue_discards = 1' to /etc/lvm/lvm.conf
 - Add cron job to /etc/cron.daily
