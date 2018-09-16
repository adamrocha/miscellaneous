#!/bin/bash
# Get current swap usage for all running processes

SUM=0
OVERALL=0
for DIR in $(find /proc/ -maxdepth 1 -type d | grep -E "^/proc/[0-9]")
#for DIR in $(find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+")
do
    PID=$(echo "$DIR" | cut -d / -f 3)
    PROGNAME=$(ps -p "$PID" -o comm --no-headers)
    for SWAP in $(grep Swap "$DIR"/smaps 2>/dev/null | awk '{ print $2 }')
#    for SWAP in $(grep VmSwap "$DIR"/status 2>/dev/null | awk '{ print $2 }')
    do
        (( SUM=SUM+SWAP ))
    done
    if [ "$SUM" -gt 0 ]
    then
    echo "PID=$PID - Swap used: $SUM - ($PROGNAME)"
  fi
    (( OVERALL=OVERALL+SUM ))
    SUM=0
done
echo "Overall swapped: $OVERALL KB"
