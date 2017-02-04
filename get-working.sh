#!/usr/bin/env bash
#
#
#
# Run this script using sudo get-working.sh
########

#!/bin/bash
echo "Please enter the domain name for the site: "
read domain_name
echo "Please enter the development subdomain for the site: "
read development_name
echo "Please enter the database name for the site: "
read database_name
echo "Please enter the root MYSQL password: "
read root_mysql
echo "Please enter the site_access MYSQL password: "
read access_mysql
echo "Please enter admin name for the site: "
read admin_name
echo "Please enter admin password for the site: "
read admin_password
echo "You entered the following information.

  Domain name: $domain_name
  Development subdomain: $development_name
  Database name: $database_name
  Admin name: $admin_name
  Admin password: $admin_password

"
read -p "Are these correct? (y/n) " confirm_names



# Create a diretory variable
dir="$(dirname "$0")"

GIT="$dir/lists/git.list"
GSETTINGS="$dir/lists/gsettings.list"
INSTALL="$dir/lists/install.list"
NPM="$dir/lists/npm-globals.list"
REMOVE="$dir/lists/remove.list"

echo $dir
echo $REMOVE

apt-get update
apt-get upgrade -y
apt-get remove -y $(cat $REMOVE)
apt-get install -y $(cat $INSTALL)
apt-get -y autoclean && sudo apt-get -y autoremove

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

npm install -g $(cat $NPM)

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


## UNRESOLVED
## These commands have not been intergrated into the script yet.
#
# echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
#
# sudo add-apt-repository multiverse
# sudo apt update && sudo apt install steam
#
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# sudo apt-get update
# sudo apt-get install -y mongodb-org
#
#
# sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
# curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
# sudo apt-get update
# sudo apt-get install heroku
# heroku login
