#!/usr/bin/env bash
#
#
#
# Run this script using sudo get-working.sh
########

# Create a diretory variable
dir="$(dirname "$0")"

INSTALL="$dir/lists/install.list"
REMOVE="$dir/lists/remove.list"

echo $dir
echo $REMOVE

apt-get update
apt-get upgrade -y
apt-get remove -y $(cat $REMOVE)
apt-get install -y $(cat $INSTALL)
apt-get -y autoclean && sudo apt-get -y autoremove


while IFS= read line
do
    eval git config --global $line
done < "$GIT"


while IFS= read line
do
    eval gsettings set $line
done < "$GSETTINGS"
