#!/bin/bash

## System settings to change
# Set new hostname for the machine

set_hostname () {
  read -p "What would you like the hostname to be of this machine?" hostname
  sudo scutil --set HostName "$hostname"
  dscacheutil -flushcache
}

create_repos_dir () {
  echo -e "Creating repos directory in the user's home folder..."
  mkdir ~/repos
  echo "Moving new_setup_config repository to repos directory..."
  mv ../new_setup_config ~/repos/new_setup_config
  echo -e "Making scripts executable..."
  chmod +x ~/repos/new_setup_config/resources/*
}