#!/bin/bash -xe

REPO=$1
REPONAME=$(basename "$REPO")
BUNDLEDIR=~/bundles
BUNDLEFILE="$REPONAME-$(date +%s)"
TAG="$REPONAME-lastsync"

if [ -d $REPO ]; then
	cd "$REPO"
	git pull
	git bundle create $BUNDLEDIR/$BUNDLEFILE $TAG
	git tag -f $TAG
fi
