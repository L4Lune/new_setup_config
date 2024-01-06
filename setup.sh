#!/bin/bash

echo "Starting Setup..."

# Add repos directory
mkdir ~/repos
cd ~/repos

### TERMINAL CHANGES
# Install Oh-My-ZSH
echo "Installing Oh-My-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add alias to change zsh theme
echo "Adding 'ztheme' alias to ~.zshrc to change ZSH_THEME"
echo "alias ztheme='(){ export ZSH_THEME="$@" && source ~/.zshrc }'" >> ~/.zshrc

# Change zsh theme to steeef
ztheme steeef

### DOCK CHANGES
# Dock Hiding
echo "Is Dock Hiding enabled in Settings? Press any key after confirming it is enabled."

# while loop to wait for user to press any key
read -s -n 1

# Add dock hiding animation settings
defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0.4 && killall Dock

# Add 6 small spacers
i=1
while [ $i -le 6 ]
do
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
  i=$(( $i + 1 ))
done

### APPLICATION INSTALL
# Install XCode CLI
echo "Installing XCode CLI..."
xcode-select --install

# Install HomeBrew if not already installed
echo "Checking if HomeBrew is installed..."
if test ! $(which brew); then
    echo "Installing HomeBrew..."
    /bin/bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install BrewFile
echo "Installing applications with HomeBrew..."
brew bundle install --file=./Brewfile