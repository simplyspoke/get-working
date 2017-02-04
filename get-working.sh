#!/usr/bin/env bash
#
#
#
# Run this script using sudo get-working.sh
########

# Create a diretory variable
dir="$(dirname "$0")"

GIT="$dir/lists/git.list"
GSETTINGS="$dir/lists/gsettings.list"
INSTALL="$dir/lists/install.list"
REMOVE="$dir/lists/remove.list"

echo $dir
echo $REMOVE

apt-get update
apt-get upgrade -y
apt-get remove -y $(cat $REMOVE)
apt-get install -y $(cat $INSTALL)
apt-get -y autoclean && sudo apt-get -y autoremove

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash


echo vm.swappiness=10 | tee -a /etc/sysctl.conf
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf
sysctl -p


ln -s /usr/bin/terminator /usr/bin/gnome-terminal


while IFS= read line
do
    eval git config --global $line
done < "$GIT"


while IFS= read line
do
    eval gsettings set $line
done < "$GSETTINGS"


service ssh restart
