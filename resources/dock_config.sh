#/bin/bash

### DOCK OPTIONS

# Reset Dock to default
reset_dock () {
  defaults delete com.apple.dock; killall Dock
}

# Dock Hiding
dock_hiding () {
  echo -e "${MAGBG}Enabling Dock Hiding...${ENDCOLOR}"
  defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0.4 && killall Dock
}

# Add 6 small spacers to Dock
add_dock_spacers () {
  echo -e "${MAGBG}Adding spacers for dock organization...${ENDCOLOR}"
  i=1
  while [ $i -le 6 ]
  do
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
    i=$(( $i + 1 ))
  done
}

# Add applications to the dock
add_apps_to_dock () {
echo "Adding applications to dock..."
while read applications; do
	defaults write com.apple.dock persistent-apps -array-add "<dict>
                <key>tile-data</key>
                <dict>
                    <key>file-data</key>
                    <dict>
                        <key>_CFURLString</key>
                        <string>/Volumes/Macintosh HD/Applications/'${applications}.app'</string>
                        <key>_CFURLStringType</key>
                        <integer>0</integer>
                    </dict>
                </dict>
            </dict>"
done < ~/repos/new_setup_config/resources/applications_to_dock
killall Dock
}
