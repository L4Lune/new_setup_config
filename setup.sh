#!/bin/bash

BLUEBG="\033[37;44m"
GREENBG="\033[32;44m"
MAGBG="\033[35;44m"
REDBG="\033[41;44m"
ENDCOLOR="\033[0m"

echo -e "${BLUEBG}Starting Setup...${ENDCOLOR}"
echo ""

# Add repos directory
echo -e "${GREENBG}Creating repos directory in the user's home folder...${ENDCOLOR}"
mkdir ~/repos
echo "Moving cloned git repository to repos directory..."
mv ../new_setup_config ~/repos/new_setup_config
echo -e "${GREENBG}Making scripts executable...${ENDCOLOR}"
chmod +x ~/repos/new_setup_config/*
cd ~/repos

while true; do
  read -p "${BLUEBG}Would you like to configure Github username, email, and SSH authentication for this machine? (y/n)${ENDCOLOR} " yn

    case $yn in
      [yY] ) ./github_config.sh
             break;;
      [nN] ) echo "${MAGBG}Skipping Github configuration...${ENDCOLOR}"
             break;;
      [*]  ) echo "${REDBG}Invalid response${ENDCOLOR}";;
    esac
done

### TERMINAL CHANGES
# Install Oh-My-ZSH
echo -e "${BLUEBG}Installing Oh-My-ZSH...${ENDCOLOR}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Add alias to change zsh theme
echo -e "${GREENBG}Adding 'ztheme' alias to ~/.zshrc to change ZSH_THEME...${ENDCOLOR}"
cat << 'EOF' >> ~/.zshrc
alias ztheme='(){ export ZSH_THEME="$@" && source $ZSH/oh-my-zsh.sh }'
EOF

# Change zsh theme to steeef
echo -e "${MAGBG}Changing theme to steeef${ENDCOLOR}"
/bin/zsh ztheme steeef

### DOCK CHANGES
# Dock Hiding
# Add dock hiding animation settings
echo -e "${MAGBG}Enabling Dock Hiding...${ENDCOLOR}"
defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0.4 && killall Dock

# Add 6 small spacers
echo -e "${MAGBG}Adding spacers for dock organization...${ENDCOLOR}"
i=1
while [ $i -le 6 ]
do
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
  i=$(( $i + 1 ))
done

### APPLICATION INSTALL
# Install XCode CLI
echo -e "${BLUEBG}Installing XCode CLI...${ENDCOLOR}"
xcode-select --install

# Install HomeBrew if not already installed
echo -e "${BLUEBG}Checking if HomeBrew is installed...${ENDCOLOR}"
if test ! $(which brew); then
    echo -e "${BLUEBG}Installing HomeBrew...${ENDCOLOR}"
    /bin/bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add HomeBrew to PATH
    echo -e "${BLUEBG}Adding HomeBrew to PATH...${ENDCOLOR}"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Install from BrewFile
    echo -e "${BLUEBG}Installing applications with HomeBrew...${ENDCOLOR}"
    brew bundle install --file=~/repos/new_setup_config/Brewfile

    # Install VS Code Extensions
    echo -e "${BLUEBG}Installing VS Code extenstions...${ENDCOLOR}"
    while read extension; do 
      code --install-extension $extension
    done < vscode_ext

    echo -e "${GREENBG}VS Code extension installation complete...${ENDCOLOR}"
else
    echo -e "${MAGBG}Skipping HomeBrew installation...${ENDCOLOR}"
    echo -e "${BLUEBG}Updating installed applications...${ENDCOLOR}"
    brew tap buo/cask-upgrade
    brew bundle cleanup --file=~/repos/new_setup_config/Brewfile
    brew bundle check --file=~/repos/new_setup_config/Brewfile
    brew cu
fi

# Return to home directory
cd ~

# Reload Shell
echo -e "${GREENGB}Setup complete. Please reload your shell...${ENDCOLOR}"
source zsh -l