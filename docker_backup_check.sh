#!/usr/bin/env bash
# Report failed backup cycles scheduled Saturdays ~ 06:30.
# Author: Adam Rocha 2020-08-17
# Modified: Adam Rocha 2020-10-28

currentTime=$(date +%s)

# UCP backup repository
UCPbackupFileCreated=$(stat -c %X "$(find /var/lib/dtr_backup/ucp/ -type f -size +100M -exec ls -1rt {} + |tail -1)")
UCPdifference=$((currentTime - UCPbackupFileCreated))
UCPsinceDate=$(date -d@"$UCPbackupFileCreated")

# DTR backup repository
DTRbackupFileCreated=$(stat -c %X "$(find /var/lib/dtr_backup/dtr/ -type f -size +100M -exec ls -1rt {} + |tail -1)")
DTRdifference=$((currentTime - DTRbackupFileCreated))
DTRsinceDate=$(date -d@"$DTRbackupFileCreated")

# Last backups exceeding 8 day threshold
if [ $UCPdifference -ge 691200 ] || [ $DTRdifference -ge 691200 ] ; then
  echo "Error: One or more backups failed. UCP completed $UCPsinceDate. DTR completed $DTRsinceDate."
  exit 2
else
  echo "OK - Backups on schedule."
  exit 0
fi
