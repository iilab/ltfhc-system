#!/bin/bash

# USAGE
#   $0 SOURCEDB DESTHOST [DESTDIR]

DEFAULTDEST=.
HOST=$2

if [ $# -lt 2 ]; then
	printf "Usage\n  $0 SOURCEDB DESTHOSTNAME [DESTDIR]"
	exit 1
fi

if [ $HOST = "nkasi" ]; then
	printf "Do not run this script on nkasi!"
	exit 1
fi

if [ -e $1 ]; then
	SOURCEDB=$1
else
	echo "$1 does not exist."
	exit 1
fi

if [ $# -eq 3 ] && [ -d $3 ]; then
	DESTDIR=$3
else
	DESTDIR=$DEFAULTDEST
fi

printf "Using default destination directory $DESTDIR"

head -1 $SOURCEDB | grep -q "SQLite format 3"
CHECKEXIT=$?

if [ $CHECKEXIT != 0 ]; then
	printf "$SOURCEDB is not a valid SQLite 3 database"
	exit $CHECKEXIT
fi

BASEDIR=$(dirname $SOURCEDB)
BASE=$(basename $SOURCEDB)

ORIG=$DESTDIR/${BASE}-orig.sql
NEW=$DESTDIR/${BASE}-$(date "+%s").sql

PATCH=$DESTDIR/${BASE}-$(date "+%s").patch

if [ -e $ORIG ]; then
	printf "Creating new file."
	OUT=$NEW
	NOMORE=0
else
	printf "No original file to diff. Creating one."
	OUT=$ORIG
	NOMORE=1
fi

sqlite3 ${SOURCEDB} ".dump" > ${OUT}

if [ ${NOMORE} -eq 1 ]; then
	printf "Generating Patch"
	diff -c $ORIG $NEW > $PATCH
	$OUT=$PATCH
	rm $NEW
fi

printf "Queuing file transfer"

UUCPPATH="nkasi!$HOST!/usr/spool/uucppublic/$HOST/$OUT"

gzip -9 $OUT

uucp -r $OUT.gz $UUCPPATH
CHECKEXIT=$?

if [ $CHECKEXIT != 0 ]; then
	printf "File copy couldn't be queued."
	exit $CHECKEXIT
fi

printf "Job Done"
exit 0
