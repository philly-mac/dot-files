#!/bin/bash

#install reflector to get best mirrors, curl as a dependency
pacman -S reflector curl

#move to mirrorlist directory
cd /etc/pacman.d

#back up your mirrorlist
cp mirrorlist mirrorlist.backup

#return the fastest 6 repos in your country, pipe output to mirrorlist file
reflector -c %own% -f 6 > mirrorlist

#make sure mirrorlist looks right
less mirrorlist

#force mirrors to update
pacman -Syy

#update the system
pacman -Syu