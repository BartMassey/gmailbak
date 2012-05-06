#!/bin/sh
# Copyright © 2012 Bart Massey
# This work is available under the MIT license.
# See the file COPYING in this distribution for
# license details.
#
# Backup Gmail using POP3
#
# Fix the BASEDIR to point at your storage
# if it is different from ~gmailbak.
BASEDIR="$HOME"
PGM="`basename $0`"
if [ $USER != gmailbak ]
then
    echo "$PGM: run this script as user gmailbak" >&2
    exit 1
fi
cd
for CONF in "$HOME"/*.conf
do
    ACCT="`basename \"$CONF\" .conf`"
    DIR=$BASEDIR/$ACCT
    DELIVER=$DIR/new
    MTIME="`stat -c '%Y' \"$DELIVER\"`"
    if [ $? -ne 0 ]
    then
        echo "$PGM: stat of $DELIVER failed" >&2
        exit 1
    fi
    while true
    do
        # If getmail interacts with Gmail
        # but fails to retrieve any messages,
        # it exits with 0. Thus, we check the
        # ctime of the delivery directory to
        # see if any new messages were put in
        # it. If so, we run again; Gmail may
        # send just part of the available mail
        # stream.
        getmail --quiet \
          --getmaildir="$DIR" \
          --rcfile="$CONF" &&
        MTIME2="`stat -c '%Y' $DELIVER`"
        if [ $? -ne 0 ]
        then
            echo "$PGM: getmail or stat of $DELIVER failed: $?" >&2
            exit 1
        fi
        [ $MTIME2 -le $MTIME ] && break
        MTIME=$MTIME2
        sleep 60
    done
done
