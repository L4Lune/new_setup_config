#!/bin/bash

BLUEBG = "\033[37;44m"
GREENBG = "\033[32;44m"
MAGBG = "\033[35;44m"
REDBG = "\033[41;44m"
ENDCOLOR = "\e[0m"

echo -e "${BLUEBG}Starting Setup...${ENDCOLOR}"
echo ""

# Add repos directory
echo -e "${GREENBG}Creating repos directory in the user's home folder...${ENDCOLOR}"
mkdir ~/repos
echo "Moving cloned git repository to repos directory..."
mv ../new_setup_config ~/repos/new_setup_config
echo -e "${GREENBG}Making scripts executable...${ENDCOLOR}"
chmod +x ~/repos/new_setup_config/tools/*
cd ~/repos

while true; do
  read -p "${BLUEBG}Would you like to configure Github username, email, and SSH authentication for this machine? (y/n)${ENDCOLOR} " yn

    case $yn in
      [yY] ) ./tools/github_config.sh;;
             break;;
      [nN] ) echo "${MAGBG}Skipping Github configuration...${ENDCOLOR}";;
             break;;
      [*]  ) echo "${REDBG}Invalid response${ENDCOLOR}";;
    esac
done

### TERMINAL CHANGES
# Install Oh-My-ZSH
echo "Installing Oh-My-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Add alias to change zsh theme
echo "Adding 'ztheme' alias to ~/.zshrc to change ZSH_THEME"
cat << 'EOF' >> ~/.zshrc
alias ztheme='(){ export ZSH_THEME="$@" && source $ZSH/oh-my-zsh.sh }'
EOF

# Change zsh theme to steeef
/bin/zsh ztheme steeef

### DOCK CHANGES
# Dock Hiding
# Add dock hiding animation settings
defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0.4 && killall Dock

# Add 6 small spacers
echo "Adding spacers for dock organization."
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

# Add HomeBrew to PATH
echo "Adding HomeBrew to PATH"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install BrewFile
echo "Installing applications with HomeBrew..."
brew bundle install --file=~/repos/new_setup_config/Brewfile

# Install VS Code Extensions
echo "Installing VS Code extenstions..."
while read extension; do 
  code --install-extension $extension
done < vscode_ext

echo "VS Code extension installation complete."
# Return to home directory
cd ~

# Reload Shell
echo "Please reload your shell"
source zsh -l