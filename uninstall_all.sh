#!/bin/bash
/bin/zsh uninstall_oh_my_zsh
brew remove --force $(brew list --formula)
brew remove --cask --force $(brew list)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
defaults delete com.apple.dock; killall Dock
rm -rf ~/repos
