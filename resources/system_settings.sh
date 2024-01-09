#!/bin/bash

### System settings to change
# Set all settings
set_all_settings () {
  set_hostname
  enable_tap_to_click
  show_path_bar
  finder_to_search_current_folder
  set_hot_corners
}

# Set new hostname for the machine
set_hostname () {
  read -p "What would you like the hostname to be of this machine?" hostname
  echo "Setting Computername, HostName, and LocalHostName..."
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set HostName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
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

enable_tap_to_click () {
  echo "Enabling tap to click functionality for the trackpad..."
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
}

show_path_bar () {
  echo "Enabling path bar..."
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  killall Finder
}

finder_to_search_current_folder () {
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
}

set_hot_corners () {
  # Top left screen corner → Mission Control
  defaults write com.apple.dock wvous-tl-corner -int 2
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Top right screen corner → Notification Center
  defaults write com.apple.dock wvous-tr-corner -int 12
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Bottom left screen corner → Start screen saver
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0
  # Bottom right screen corner → Put display to sleep
  defaults write com.apple.dock wvous-br-corner -int 10
  defaults write com.apple.dock wvous-br-modifier -int 0
}