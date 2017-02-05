#!/usr/bin/env bash
#
#
#
# Run this script using sudo get-working.sh
########

echo "Please enter your fullname: "
read FULLNAME
echo "Please enter your email (for git and etc.): "
read EMAIL

read -p "Would you like to install MongoDB? (y/n) " MONGODB
MONGODB="${MONGODB:-y}"
if [ "$MONGODB" = "y" ]; then
  read -p "Are these correct? (y/n) " MONGODB_CONFIRMED
fi

echo "You entered the following information.

  Your name: $FULLNAME
  Your email: $EMAIL
  
  Would you like to install MongoDB? $MONGODB

"
read -p "Are these correct? (y/n) " CONFIRMED

if [ "$CONFIRMED" = "y" ]; then
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

fi
