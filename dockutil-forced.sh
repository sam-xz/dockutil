#!/bin/bash
#Samuel Marino 28/Nov/2023
#Install dockutil if not found and configure apps, applications stack, downloads fan sorted by date added. Recents left on by default. 
#Checks app if is installed first before adding to dock to avoid the "?" icon if missing.

# some vars
CurrUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
killall="/usr/bin/killall"

# Check if the script has already been run for the current user
if [ -f "/Users/$CurrUser/jumpcloud/.dock_setup_completed" ]; then
    echo "[EXIT] Default Dock setup already completed for this user. Exiting..."
    exit 0
fi

# check if dockutil is installed, install if it's not.
dockutil="/usr/local/bin/dockutil"
if [[ -x $dockutil ]]; then
    echo "[OK] DockUtil already installed, continuing... "
else
    echo "[INSTALL] Dockutil not found...installing now..."
    curl -L --silent --output /tmp/dockutil.pkg "https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg" >/dev/null
    # install dockutil
    installer -pkg "/tmp/dockutil.pkg" -target /
fi

#CurrUserHome="/Users/$CurrUser"
#UserPlist=$CurrUserHome/Library/Preferences/com.apple.dock.plist
#Uncomment the above if you want to set the dock just for the current user and change --allhome to $UserPlist on all lines
################################################################################
# Use Dockutil to Modify Logged-In User's Dock
################################################################################
echo "------------------------------------------------------------------------"
echo "I am $CurrUser"
echo "------------------------------------------------------------------------"

echo "Clearing the Dock..."
sudo -u $CurrUser $dockutil --remove all --no-restart --allhomes

add_app_to_dock "/Applications/Google Chrome.app"
add_app_to_dock "/Applications/Slack.app"
add_app_to_dock "/Applications/News.app"
add_app_to_dock "/Applications/Notes.app"
add_app_to_dock "/Applications/OpenVPN Connect/OpenVPN Connect.app"
add_app_to_dock "/Applications/1Password.app"
add_app_to_dock "/Applications/1Password 7.app"
add_app_to_dock "/System/Applications/System Settings.app"

sudo -u $CurrUser $dockutil --add "/Applications" --section others --view grid --display stack --sort name --no-restart --allhomes
sudo -u $CurrUser $dockutil --add "~/Downloads" --section others --view fan --display folder --sort dateadded --no-restart --allhomes
sudo -u $CurrUser $killall Dock

# Create a file to mark that the script has been run for this user
mkdir -p "/Users/$CurrUser/jumpcloud"
touch "/Users/$CurrUser/jumpcloud/.dock_setup_completed"

exit 0
