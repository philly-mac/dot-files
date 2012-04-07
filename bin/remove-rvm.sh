#!/bin/bash

rvm implode
rm ~bin/rvm*
rm -rf ~/.rvm*
sudo rm -rf /etc/rvm*
sudo groupdel rvm
