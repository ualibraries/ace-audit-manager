#!/bin/sh
SRC=$1
SERVER=$2
DST=$3
DEBUG="--dry-run"

rsync $DEBUG -avh --ignore-existing --max-delete=-1 --progress $SRC/ $SERVER:$DST

# If local machine copy, just use cp -van $SRC/* $DST/ (ie cp -va --no-clobber $SRC/* $DST)
