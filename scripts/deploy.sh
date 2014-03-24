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

SD=${BASH_SOURCE%/*}

# Automatically re-run under sudo if we aren't root.
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   sudo ${BASH_SOURCE}
   exit
fi

cd ${SD}

echo "*** Deployment started at $(date)" >> $SD/deploy.log 2>&1

# REQUIRED: This is the system baseline tarball that unpacks into /home/ltfhc-deploy
# Includes dependencies to run the application:
#	- Couchdb
#	- NodeJS  
#	- Kanso
#	- Curl
#	- Git (compiled with no HTTP support to remove external dependencies)
if [ ! -f ./ltfhc-deploy.tar.xz ]; then
	echo -n "Retrieving deployment package..."
	wget http://commondatastorage.googleapis.com/ltfhc/ltfhc-deploy.tar.xz >> $SD/deploy.log 2>&1
	echo "Done"
fi

# REQUIRED: The script clones the ltfhc-next.bundle into /home/ltfhc-deploy/ltfhc-next
if [ ! -f ./ltfhc-next.deploy.bundle ]; then
	echo -n "Retrieving deployment git bundle..."
	wget http://storage.googleapis.com/ltfhc/ltfhc-next.deploy.bundle >> $SD/deploy.log 2>&1
	echo "Done"
fi

# OPTIONAL: The script copies any GIT bundles it finds into the /home/ltfhc-deploy/bundles directory
if [ ! -f ./*.bundle ]; then
	echo "No GIT bundles found. Place *.bundle files in the directory where this script resides."
	exit 1
fi

echo -n "1. Uncompressing deployment files..."
tar Jxf ltfhc-deploy.tar.xz -C / >> $SD/deploy.log 2>&1
echo "Done"

echo -n "2. Installing startup scripts..."
ln -sf /home/ltfhc-deploy/etc/init.d/couchdb /etc/init.d/couchdb  >> $SD/deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/default/couchdb /etc/default/couchdb  >> $SD/deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb  >> $SD/deploy.log 2>&1
update-rc.d couchdb defaults >> $SD/deploy.log 2>&1
rm -f /etc/nginx/sites-enabled/* >> $SD/deploy.log 2>&1
ln -sf /home/ltfhc-deploy/etc/nginx/health /etc/nginx/sites-enabled/health >> $SD/deploy.log 2>&1
service nginx stop >> $SD/deploy.log 2>&1
service nginx start >> $SD/deploy.log 2>&1
echo "Done"

echo -n "3. Changing file permissions..."
groupadd -f couchdb >> $SD/deploy.log 2>&1
useradd -d /home/ltfhc-deploy -s /bin/bash -g couchdb couchdb  >> $SD/deploy.log 2>&1
chown -R couchdb:couchdb /home/ltfhc-deploy/etc /home/ltfhc-deploy/var /home/ltfhc-deploy/share/couchdb  >> $SD/deploy.log 2>&1
echo "Done"

echo -n "4. Starting database..."
# Configure CouchDB Redirect on root URL
service couchdb start >> $SD/deploy.log 2>&1
sleep 5
echo "Done"

echo -n "5. Installing application..."
# Install default instance_settings
. /home/ltfhc-deploy/env.sh >> $SD/deploy.log 2>&1
# curl -X PUT http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr >> $SD/deploy.log 2>&1
# curl -X POST -H "Content-Type: application/json" -d '{"_id":"_local/instance_settings","type":"prod","clinic":"'${HOSTNAME}'"}' http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr/ >> $SD/deploy.log 2>&1

# Install database in correct place
cp *.bundle /home/ltfhc-deploy/bundles/
cd /home/ltfhc-deploy/ 
git clone bundles/ltfhc-next.deploy.bundle ltfhc-next >> $SD/deploy.log 2>&1
cd /home/ltfhc-deploy/ltfhc-next
kanso push http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr >> $SD/deploy.log 2>&1
echo "Done."

echo -n "6. Testing application..."
curl -s http://deploy:chaiveisai9paifeich4ro0yohTiebie@localhost:5984/emr/_design/emr/_rewrite/|grep -i LTFHC >> $SD/deploy.log 2>&1
echo "Done."

echo -n "7. Bootstrapping replication..."
cd /home/ltfhc-deploy/ltfhc-next/system/python-requests 
python setup.py install >> $SD/deploy.log 2>&1
/home/ltfhc-deploy/ltfhc-next/system/replication/bootstrap.py >> $SD/deploy.log 2>&1
echo "Done."

echo "System ready for testing in the browser at https://www.health/"

exit 0

