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
	5] Nevermind, I am just winging it here with this computer (Exit the Program)
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

			### INSTALL HOMEBREW AND APPLICATIONS
			install_homebrew_and_apps

			### INSTALL VSCODE EXTENSIONS
			install_vscode_ext
			### DOCK CHANGES
			configure_dock
			echo "Please add your new SSH key to Github for authentication."
			echo "Please rearrange the Dock icons and spacers to your liking"
			break
			;; # Case 0 complete

		"1")
			while true; do
				read -p "Select an option to continue configuring Git and Github settings for this machine: " gitOptions
				cat <<-EOF
				0] Full Git reconfiguration
				1] Configure Git display name and email
				2] Generate a new SSH key pair and add to the SSH Agent
				3] Add an imported SSH key to the SSH Agent
				4] Add the Github Host configuration to ~/.ssh/config
				5] Exit the Program
				EOF

				case $gitOptions in
					"0")
						configure_git
						break;;
					"1")
						configure_git_email_display_name
						break;;
					"2")
						generate_gh_ssh_key
						break;;
					"3")
						start_ssh_agent
						add_ssh_key_to_agent
						break;;
					"4")
						append_gh_content_ssh_config
						break;;
					"5")
						echo "You can rerun this program at any time to update these configurations."
						exit;;
				esac
			done
			;; # Case 1 complete
			
			"2") 
			


			
	esac
done






# Return to home directory
cd ~

# Reload Shell
echo -e "${GREENGB}Setup complete. Please reload your shell...${ENDCOLOR}"
source zsh -l