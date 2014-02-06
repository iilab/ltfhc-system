#!/bin/bash

# trap handler: print location of last error and process it further
#
function the_trap_handler()
{
        MYSELF="$0"               # equals to my script name
        LASTLINE="$1"            # argument 1: last line of error occurence
        LASTERR="$2"             # argument 2: error code of last command
        echo "${MYSELF}: line ${LASTLINE}: exit status of last command: ${LASTERR}"

        exit 1
}

# trap commands with non-zero exit code
#
trap 'the_trap_handler ${LINENO} $?' ERR

# Automatically re-run under sudo if we aren't root.
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   sudo "$0"
   exit
fi

echo "*** Deployment started at $(date)" >> deploy.log 2>&1

# REQUIRED: This is the system baseline tarball that unpacks into /home/ltfhc-deploy
# Includes dependencies to run the application:
#	- Couchdb
#	- NodeJS  
#	- Kanso
#	- Curl
#	- Git (compiled with no HTTP support to remove external dependencies)
if [ ! -f ./ltfhc-deploy.tar.xz ]; then
	echo -n "Retrieving deployment package..."
	wget http://commondatastorage.googleapis.com/ltfhc%2Fltfhc-deploy.tar.xz >> deploy.log 2>&1
	echo "Done"
fi

# REQUIRED: The script clones the ltfhc-next.bundle into /home/ltfhc-deploy/ltfhc-next
if [ ! -f ./ltfhc-next.bundle ]; then
	echo "ltfhc-next.bundle bundle not found. Place the ltfhc-next.bundle file in the directory where this script resides."
	exit 1
fi

# OPTIONAL: The script copies any GIT bundles it finds into the /home/ltfhc-deploy/bundles directory
if [ ! -f ./*.bundle ]; then
	echo "No GIT bundles found. Place *.bundle files in the directory where this script resides."
	exit 1
fi

echo -n "1. Uncompressing deployment files..."
tar Jxf ltfhc-deploy.tar.xz -C / >> deploy.log 2>&1
echo "Done"

echo -n "2. Installing startup scripts..."
ln -sf /home/ltfhc-deploy/etc/init.d/couchdb /etc/init.d/couchdb  >> deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/default/couchdb /etc/default/couchdb  >> deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb  >> deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/init/stunnel /etc/init/stunnel
initctl reload-configuration
initctl start stunnel
update-rc.d couchdb defaults >> deploy.log 2>&1
echo "Done"

echo -n "3. Changing file permissions..."
groupadd -f couchdb >> deploy.log 2>&1
useradd -d /home/ltfhc-deploy -s /bin/bash -g couchdb couchdb  >> deploy.log 2>&1
chown -R couchdb:couchdb /home/ltfhc-deploy/etc /home/ltfhc-deploy/var /home/ltfhc-deploy/share/couchdb  >> deploy.log 2>&1
echo "Done"

echo -n "4. Starting database..."
service couchdb start >> deploy.log 2>&1
echo "Done"

echo -n "5. Installing application..."
cp *.bundle /home/ltfhc-deploy/bundles/
. /home/ltfhc-deploy/env.sh >> deploy.log 2>&1
cd /home/ltfhc-deploy/ 
git clone bundles/ltfhc-next.bundle >> deploy.log 2>&1
cd /home/ltfhc-deploy/ltfhc-next
kanso push http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr >> deploy.log 2>&1
echo "Done."

echo -n "6. Testing application..."
curl -s http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr/_design/emr/_rewrite/|grep -i LTFHC >> deploy.log 2>&1
echo "Done."

