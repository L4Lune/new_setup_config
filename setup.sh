#!/bin/bash

echo "Starting Setup..."

### TERMINAL CHANGES
# Install Oh-My-ZSH
echo "Installing Ih-My-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add alias to change zsh theme
echo "Adding 'ztheme' alias to ~.zshrc to change ZSH_THEME"
echo "alias ztheme='(){ export ZSH_THEME="$@" && source ~/.zshrc }'" >> ~/.zshrc

# Change zsh theme to steeef
ztheme steeef

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