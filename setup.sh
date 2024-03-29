#!/bin/bash

# Source scripts
source ./resources/git_config.sh
source ./resources/oh_my_zsh_config.sh
source ./resources/homebrew_and_app_config.sh
source ./resources/dock_config.sh
source ./resources/system_settings.sh

# Colors (THIS NEEDS TO BE REWORKED TO LOOK GOOD)
BLUEBG="\033[37;44m"
GREENBG="\033[32;44m"
MAGBG="\033[35;44m"
REDBG="\033[41;44m"
ENDCOLOR="\033[0m"

echo -e "Starting Setup..."
echo ""

while true; do
	cat <<-EOF
  Select an option to continue configuration process: 
	0] To configure a new machine to the preferred baseline
	1] Git/Github Options
	2] Installation Options
	3] Dock Customization Option
	4] Nevermind, I am just winging it here with this computer (Exit the Program)
	EOF
  read -p "Enter response: " option

	case $option in
		"0")
			### SYSTEM SETTINGs
			# Set settings
			set_all_settings

			# Create repos directory + make executable
			create_repos_dir

			cd ~/repos

			# Install XCode CLI
			echo -e "Installing XCode CLI..."
			xcode-select --install	

			### GIT OPTIONS
			configure_git

			### OH-MY-ZSH OPTIONS
			configure_omz

			### INSTALL HOMEBREW AND APPLICATIONS
			configure_homebrew_and_apps

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
				cat <<-EOF
        Select an option to continue configuring Git and Github settings for this machine:
				0] Full Git reconfiguration
				1] Configure Git display name and email
				2] Generate a new SSH key pair and add to the SSH Agent
				3] Add an imported SSH key to the SSH Agent
				4] Add the Github Host configuration to ~/.ssh/config
				5] Exit the Program
				EOF
        read -p "Enter response: " gitOptions

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
				while true; do
					cat <<-EOF
          Please select an installation option: 
					0] Install HomeBrew and Applications
					1] Install HomeBrew Applications
					2] Install Oh-My-ZSH
          3] Exit the Program
					EOF
          read -p "Enter response: " installOptions

					case $installOptions in
						"0")
							install_homebrew_and_apps
							break;;
						"1")
							install_apps_from_brewfile
							break;;
						"2")
							configure_omz
							break;;
            "3")
              echo "Exiting the Program..."
              exit;;
					esac
				done
				;; # Case 2 complete

			"3")
				while true; do
					
					cat <<-EOF
          Select a Dock customization option: 
					0] Reset Dock to default
					1] Enable Dock hiding
					2] Add spacers to the Dock
					3] Add applications to the Dock
					4] Exit the Program
					EOF
					
          read -p "Enter response: " dockOptions
					case $dockOptions in
					"0")
					 reset_dock
					 break;;
					"1")
						dock_hiding
						break;;
					"2")
						add_dock_spacers
						break;;
					"3")
						add_apps_to_dock
						break;;
					"4")
						echo "Exiting the program."
						exit;;
					esac
				done
				;; # Case 3 complete
			
			"4")
				echo "Good luck out there. Come back anytime!"
				exit;;
	esac
done

# Return to home directory
cd ~

# Reload Shell
echo -e "Setup complete. Please reload your shell..."