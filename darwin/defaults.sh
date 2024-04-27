#!/usr/bin/env bash 

# disable mac os' weird mouse handling
defaults write -g com.apple.mouse.scaling 1.0

# disable DS_Store on SMB shares
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true 

# disable DS_Store on USBs
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true 

