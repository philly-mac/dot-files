#!/bin/bash

[[ `id -u` != 0 ]] && \
    echo 'Run this script as root' && \
    exit 1

RSNAPSHOT=`which rsnapshot`

if [[ -d "/media/SUPER-MAC-BACKUP/encrypted" ]]; then

  if [[ -e "/media/SUPER-MAC-BACKUP/encrypted/unencrypted" ]]; then
    echo "Encrypted Backup"
    $RSNAPSHOT -v -c /home/philip/bin/rsnapshot/rsnapshot_encrypted.conf daily
  else
    echo "Backup still encrypted"
    exit 1
  fi
else
  echo "Backup not mounted"
  exit 1
fi

if [[ -d "/media/SUPER-MAC-BACKUP/unencrypted" ]]; then
  $RSNAPSHOT -v -c /home/philip/bin/rsnapshot/rsnapshot_unencrypted.conf daily
else
  echo "Backup not mounted"
  exit 1
fi