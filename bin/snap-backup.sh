#!/bin/bash

[[ `id -u` != 0 ]] && \
    echo 'Run this script as root' && \
    exit 1

#[[ $1 == '' ]] && \
#    echo 'Enter a time frequency' && \
#    exit 1

if [[ -e "/media/SUPER-MAC-BACKUP/encrypted/unencrypted" ]]; then
  RSNAPSHOT=`which rsnapshot`
  $RSNAPSHOT daily
else
  echo "Backup not mounted or not encrypted"
  exit 1
fi
