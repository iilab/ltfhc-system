#!/bin/bash -xe

REPO=$1
BUNDLEDIR=~/bundles
BUNDLEFILE="$REPO-$(date +%s)"
TAG="$REPO-lastsync"

if [ -d $REPO ]; then
	cd "$REPO"
	
	# See if we need to pull or not (saves bandwidth)
	HEADREV=`git rev-parse HEAD`
	ORIGINREV=`git rev-parse origin`
	if [ "$HEADREV" != "$ORIGINREV" ]; then
		# pull if our current version is different
		git pull
	else
		# stop, no work to do
		exit 0
	fi

	git bundle create $BUNDLEDIR/$BUNDLEFILE $TAG
	git tag -f $TAG
fi
