#!/bin/bash

# APPLICATION INSTALL

# All HomeBrew Options
configure_homebrew_and_apps () {
  get_homebrew
  add_homebrew_to_path
  get_apps_from_brewfile
}

# Install HomeBrew if not already installed
get_homebrew () {
  echo -e "Checking if HomeBrew is installed..."
  if test ! $(which brew); then
      echo -e "Installing HomeBrew..."
      /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
}

# Add HomeBrew to PATH
add_homebrew_to_path () {
  echo -e "Adding HomeBrew to PATH..."
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}
      
# Install from BrewFile
get_apps_from_brewfile () {
  echo -e "Installing applications with HomeBrew..."
  brew bundle install --file=~/repos/new_setup_config/Brewfile
}

uninstall_apps_from_brewfile () {
  echo "Uninstalling all applications managed by HomeBrew..."
  brew remove --force $(brew list --formula)
  brew remove --cask --force $(brew list)
}

update_all_homebrew_apps () {
  brew bundle cleanup
  brew tap buo/cask-upgrade
  brew cu
}

uninstall_homebrew () {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

# Install VS Code Extensions
install_vscode_ext () {
  echo -e "Installing VS Code extenstions..."
  while read extension; do 
    code --install-extension $extension
  done < ./vscode_ext
}
