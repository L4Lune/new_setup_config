#!/bin/bash

# Configure the global git username and email address
configure_git_email_display_name () {
if [ -n "$(git config --global user.email)" ]; then
  echo "✔ Git email is set to $(git config --global user.email)"
	read -p 'Would you like to change the email address?' yn
	if [ "$yn" == "y" ] || [ "$yn" == "Y" ]; then
		read -p 'What is your Git email address?: ' gitEmail
  	git config --global user.email "$gitEmail"
	fi
else
  read -p 'What is your Git email address?: ' gitEmail
  git config --global user.email "$gitEmail"
fi

if [ -n "$(git config --global user.name)" ]; then
  echo "✔ Git display name is set to $(git config --global user.name)"
	read -p 'Would you like to change the display name?' yn
	if [ "$yn" == "y" ] || [ "$yn" == "Y" ]; then
		read -p 'What is your Git display name (Firstname Lastname)?: ' gitName
  	git config --global user.name "$gitName"
	fi
else
  read -p 'What is your Git display name (Firstname Lastname)?: ' gitName
  git config --global user.name "$gitName"
fi
}

# Generate a new SSH key to upload to Github
generate_gh_ssh_key () {
	echo "Your Github email address will be the label for your new key."
	read -p "Enter your Github email address: " githubEmail
	ssh-keygen -t ed25519 -C "$githubEmail"
}

# Start ssh-agent in the background
start_ssh_agent () {
  echo "Starting ssh-agent..."
  eval "$(ssh-agent -s)"
}

# Add ssh key to agent
add_ssh_key_to_agent () {
	while true; do
		read -p "Did you select the default file to save the key?" yn
		case $yn in
			"Y" | "y" | "YES" | "Yes" | "yes") 
				ssh-add --apple-use-keychain ~/.ssh/id_ed25519;;
			"N" | "n" | "No" | "NO" | "no" | "nO") 	
				read -p "Enter the file path, including the name of the key, you created: " key_path
				echo "Adding SSH key to agent..."
				ssh-add --apple-use-keychain "$key_path";;
			* ) echo "Invalid response."
		esac 
	done
}

# Check if ssh config exists
create_ssh_config_if_absent () {
	echo "Checking if ~/.ssh/config exists..."
	FILE=~/.ssh/config
	if [ ! -f $FILE ]; then
		echo "~/.ssh/config does not exist. Creating it now..."
		touch ~/.ssh/config
}

append_gh_content_ssh_config () {
	local LOCAL_SSH_CONFIG_FILE="$HOME"/.ssh/config
	declare -r GH_HOST_CONFIG="
Host github.com
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_ed25519
"

	if [ ! -e "$LOCAL_SSH_CONFIG_FILE" ] || ! grep -q "$(<<<"$GH_HOST_CONFIG" tr '\n' '\01')" < <(less "$LOCAL_SSH_CONFIG_FILE" | tr '\n' '\01'); then
		echo "Appending the following content to ~/.ssh/config: "
		echo $GH_HOST_CONFIG
		printf '%s\n' "$GH_HOST_CONFIG" >> "$LOCAL_SSH_CONFIG_FILE"
	else
		echo "Github host configuration is already present in ~/.ssh/config."
  fi
}
# 	cat <<-EOF >> ~/.ssh/config
# 	Host github.com
# 		AddKeysToAgent yes
# 		UseKeychain yes
# 		IdentityFile ~/.ssh/id_ed25519
# 	EOF
# else
# 	cat <<-EOF >> ~/.ssh/config
# 	Host github.com
# 		AddKeysToAgent yes
# 		UseKeychain yes
# 		IdentityFile ~/.ssh/id_ed25519
# 	EOF
# fi
