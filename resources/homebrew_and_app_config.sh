#!/bin/bash

### APPLICATION INSTALL

# All HomeBrew Options
install_homebrew_and_apps () {
  install_homebrew
  add_homebrew_to_path
  install_apps_from_brewfile
}

# Install HomeBrew if not already installed
install_homebrew () {
  echo -e "${BLUEBG}Checking if HomeBrew is installed...${ENDCOLOR}"
  if test ! $(which brew); then
      echo -e "${BLUEBG}Installing HomeBrew...${ENDCOLOR}"
      /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Add HomeBrew to PATH
add_homebrew_to_path () {
  echo -e "${BLUEBG}Adding HomeBrew to PATH...${ENDCOLOR}"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}
      
# Install from BrewFile
install_apps_from_brewfile () {
  echo -e "${BLUEBG}Installing applications with HomeBrew...${ENDCOLOR}"
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
  echo -e "${BLUEBG}Installing VS Code extenstions...${ENDCOLOR}"
  while read extension; do 
    code --install-extension $extension
  done < ./vscode_ext
}
