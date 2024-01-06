#!/bin/bash

echo "Starting Setup..."

# Github configuration setup
if [ -n "$(git config --global user.email)" ]; then
  echo "✔ Git email is set to $(git config --global user.email)"
else
  read -p 'What is your Git email address?: ' gitEmail
  git config --global user.email "$gitEmail"
fi

if [ -n "$(git config --global user.name)" ]; then
  echo "✔ Git display name is set to $(git config --global user.name)"
else
  read -p 'What is your Git display name (Firstname Lastname)?: ' gitName
  git config --global user.name "$gitName"
fi

# Generate a new SSH key to upload to Github
echo "Enter your Github email address: "
read -p githubEmail
ssh-keygen -t ed25519 -C "$githubEmail"

# Start ssh-agent in the background
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Check if ssh config exists
echo "Checking if ~/.ssh/config exists and appending necessary configuration..."
FILE=~/.ssh/config
if [ ! -f $FILE ]
then
  touch ~/.ssh/config
  cat << EOF >> ~/.ssh/config
  Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
EOF

# Add ssh key to agent
echo "Adding SSH key to agent..."
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

echo "Be sure to upload your key to Github for authentication"

# Add repos directory
echo "Creating repos directory in the home folder..."
mkdir ~/repos
echo "Moving cloned git repository to repos directory..."
mv ../new_setup_config ~/repos/new_setup_config
cd ~/repos

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
source zsh -l