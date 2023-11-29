#!/bin/bash
# Samuel Marino 28/Nov/2023
# Preserve the dock for all users before deploying default dock to all devices

CurrUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

mkdir -p "/Users/$CurrUser/jumpcloud"
touch "/Users/$CurrUser/jumpcloud/.dock_setup_completed"