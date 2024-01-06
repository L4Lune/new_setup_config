#!/bin/bash
/bin/zsh uninstall_oh_my_zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
delete com.apple.dock; killall Dock
rm -rf ~/repos
