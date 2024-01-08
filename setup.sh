#!/bin/bash

# Source scripts
source ./resources/git_config.sh
source ./resources/oh_my_zsh_config.sh
source ./resources/homebrew_config.sh
source ./resources/dock_config.sh

# Colors (THIS NEEDS TO BE REWORKED TO LOOK GOOD)
BLUEBG="\033[37;44m"
GREENBG="\033[32;44m"
MAGBG="\033[35;44m"
REDBG="\033[41;44m"
ENDCOLOR="\033[0m"

echo -e "${BLUEBG}Starting Setup...${ENDCOLOR}"
echo ""

while true; do
	read -p "Select an option to continue configuration process: " option
	cat <<-EOF
	0] To configure a new machine to the preferred baseline
	1] Git/Github Options
	2] Installation Options
	3] Reinstallation Option
	4] Dock Customization Option
	5] Nevermind, I am just winging it here with this computer
	EOF

	case $option in
		"0")
			# Create repos directory and move repo
			echo -e "${GREENBG}Creating repos directory in the user's home folder...${ENDCOLOR}"
			mkdir ~/repos
			echo "Moving new_setup_config repository to repos directory..."
			mv ../new_setup_config ~/repos/new_setup_config
			echo -e "${GREENBG}Making scripts executable...${ENDCOLOR}"
			chmod +x ~/repos/new_setup_config/tools/*
			cd ~/repos

			# Install XCode CLI
			echo -e "${BLUEBG}Installing XCode CLI...${ENDCOLOR}"
			xcode-select --install	

			### GIT OPTIONS
			configure_git

			### OH-MY-ZSH OPTIONS
			configure_omz

			### DOCK CHANGES
			# Enable Dock Hiding
			
	esac
done




# Install VS Code Extensions
echo -e "${BLUEBG}Installing VS Code extenstions...${ENDCOLOR}"
while read extension; do 
	code --install-extension $extension
done < ~/repos/new_setup_config/vscode_ext

# Return to home directory
cd ~

# Reload Shell
echo -e "${GREENGB}Setup complete. Please reload your shell...${ENDCOLOR}"
source zsh -l