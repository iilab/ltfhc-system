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

echo "*** Deployment started at $(date)" >> deploy.log 2>&1

if [ -f 'ltfhc-deploy.tar.xz']; then

	echo -n "Uncompressing deployment files..."
	tar Jxvf ltfhc-deploy.tar.xz -C / >> deploy.log 2>&1
	echo "Done"

	echo "Installing startup scripts..."
	ln -sf /home/ltfhc-deploy/etc/init.d/couchdb /etc/init.d/couchdb  >> deploy.log 2>&1
	ln -sf /home/ltfhc-deploy/etc/default/couchdb /etc/default/couchdb  >> deploy.log 2>&1
	ln -sf /home/ltfhc-deploy/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb  >> deploy.log 2>&1
	update-rc.d defaults couchdb  >> deploy.log 2>&1
	echo "Done"

	echo "Changing file permissions..."
	useradd -d /home/ltfhc-deploy -s /bin/bash couchdb  >> deploy.log 2>&1
	chown -R couchdb:couchdb /home/ltfhc-deploy/etc /home/ltfhc-deploy/var /home/ltdhc-deploy/share/couchdb  >> deploy.log 2>&1
	echo "Done"

	echo "Starting database..."
	service couchdb startup >> deploy.log 2>&1
	echo "Done"

	echo "Installing application"
	. /home/ltfhc-deploy/env.sh
	cd /home/ltfhc-deploy/ltfhc-next 
	kanso push http://localhost:5984 >> deploy.log 2>&1

else
	echo "The file ltfhc-deploy.tar.xz is not in this directory. Please download or move it here"
	exit 1
fi
