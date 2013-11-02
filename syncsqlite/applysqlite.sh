#!/bin/bash

# USAGE
#   $0 SOURCEDB DESTDB PATCH 

if [ $# -lt 3 ]; then
	printf "Usage\n  $0 SOURCEDB DESTDB PATCH"
	exit 1
fi

if [ -e $1 ]; then
	SOURCEDB=$1
else
	printf "$1 does not exist."
	exit 1
fi

if [ -e $2 ]; then
	printf "OVERWRITING DATABASE $2. Cancel this script within 5 seconds if you do not want to delete this file."
	sleep 5
	rm $2
fi

DESTDB=$2

if [ -e $3 ]; then
	PATCH=$3
	gunzip $PATCH
	PATCH=${PATCH%.gz}
else 
	printf "$3 does not exist."
	exit 1
fi

head -1 $SOURCEDB | grep -q "SQLite format 3"
CHECKEXIT=$?

if [ $CHECKEXIT != 0 ]; then
	printf "$SOURCEDB is not a valid SQLite 3 database"
	exit $CHECKEXIT
fi

sqlite3 ${SOURCEDB} ".dump" > ${DESTDB}.sql

patch -c -N -p0 ${DESTDB}.sql ${PATCH}

sqlite3 ${DESTDB} < ${DESTDB}.sql

rm ${DESTDB}.sql*

printf "Job Done"
exit 0
