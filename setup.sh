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


read -p "Would you like to configure Github username, email, and SSH authentication for this machine? (y/n) " yn

if [ "$yn" == "y" ] || [ "$yn" == "Y" ]; then
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
	echo "Your Github email address will be the identifier for your new key."
  read -p "Enter your Github email address: " githubEmail
  ssh-keygen -t ed25519 -C "$githubEmail"

  # Start ssh-agent in the background
  echo "Starting ssh-agent..."
  eval "$(ssh-agent -s)"

  # Check if ssh config exists
  echo "Checking if ~/.ssh/config exists and appending necessary configuration..."
  FILE=~/.ssh/config
  if [ ! -f $FILE ]; then
		touch ~/.ssh/config
		cat <<-EOF >> ~/.ssh/config
		Host github.com
			AddKeysToAgent yes
			UseKeychain yes
			IdentityFile ~/.ssh/id_ed25519
		EOF
  fi

  # Add ssh key to agent
  echo "Adding SSH key to agent..."
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519

  echo "Be sure to upload your key to Github for authentication"
else
echo -e "${BLUEBG}Skipping Github configuratio...${ENDCOLOR}"
fi
### TERMINAL CHANGES
# Install Oh-My-ZSH
echo -e "${BLUEBG}Installing Oh-My-ZSH...${ENDCOLOR}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Add alias to change zsh theme
echo "Changing default .zshrc file to use the steeef theme..."
cat <<-EOF > ~/.zshrc
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="steeef"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
EOF

echo -e "${GREENBG}Adding 'ztheme' alias to ~/.zshrc to change ZSH_THEME...${ENDCOLOR}"
cat << 'EOF' >> ~/.zshrc
alias ztheme='(){ export ZSH_THEME="$@" && source $ZSH/oh-my-zsh.sh }'
EOF

### DOCK CHANGES
# Dock Hiding
# Add dock hiding animation settings
defaults delete com.apple.dock; killall Dock
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

    echo -e "${GREENBG}VS Code extension installation complete...${ENDCOLOR}"
else
    echo -e "${MAGBG}Skipping HomeBrew installation...${ENDCOLOR}"
    echo -e "${BLUEBG}Updating installed applications...${ENDCOLOR}"
    brew tap buo/cask-upgrade
    brew bundle cleanup --file=~/repos/new_setup_config/Brewfile
    brew bundle check --file=~/repos/new_setup_config/Brewfile
		brew bundle install --file=~/repos/new_setup_config/Brewfile
    brew cu
fi

# Install VS Code Extensions
echo -e "${BLUEBG}Installing VS Code extenstions...${ENDCOLOR}"
while read extension; do 
	code --install-extension $extension
done < ~/repos/new_setup_config/vscode_ext

# Add applications to the dock
echo "Adding applications to dock..."
while read applications; do
	defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$applications.app</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
done < ~/repos/new_setup_config/applications_to_dock
killall Dock
# Return to home directory
cd ~

# Reload Shell
echo -e "${GREENGB}Setup complete. Please reload your shell...${ENDCOLOR}"
source zsh -l