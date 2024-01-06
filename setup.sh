#!/bin/bash

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add alias to change zsh theme
echo "alias ztheme='(){ export ZSH_THEME="$@" && source ~/.zshrc }'"

# Change zsh theme to steeef
ztheme steeef

#