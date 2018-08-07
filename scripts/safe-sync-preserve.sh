#!/bin/sh

SRC_DIR="/mnt"
DST_DIR="/qumulo"
LOG_FILE="/tmp/safe-sync.log"

SHARE_LIST="\
afghan \
preserve"

for SHARE in $SHARE_LIST; do
  echo "SAFE_SYNC $SHARE" >> $LOG_FILE
  #time -o $LOG_FILE -a cp -van "$SRC_DIR/$SHARE" "$DST_DIR" >> $LOG_FILE 2>&1
  time -o $LOG_FILE -a rsync $DEBUG -avh --ignore-existing --max-delete=-1 --progress "$SRC_DIR/$SHARE" "$DST_DIR" >> $LOG_FILE 2>&1
done

