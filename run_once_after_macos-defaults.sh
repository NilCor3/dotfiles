#!/bin/sh
# macOS system and app defaults.
# Runs once automatically after chezmoi apply on a new machine.
# To force re-run: chezmoi state delete-bucket --bucket=scriptState

echo "Applying macOS defaults..."

###############################################################################
# Dock
###############################################################################

# Auto-hide the dock
defaults write com.apple.dock autohide -bool true
# Remove the auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
# Icon size
defaults write com.apple.dock tilesize -int 39
# Position
defaults write com.apple.dock orientation -string "bottom"
# Don't show recent apps
defaults write com.apple.dock show-recents -bool false
# Don't animate opening apps
defaults write com.apple.dock launchanim -bool false

###############################################################################
# Finder
###############################################################################

# Show path bar at the bottom
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar at the bottom
defaults write com.apple.finder ShowStatusBar -bool true
# List view as default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Show external drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# Default new window location: All My Files
defaults write com.apple.finder NewWindowTarget -string "PfAF"

###############################################################################
# Keyboard
###############################################################################

# Disable press-and-hold for keys in favor of key repeat (needed for vim modes)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# HyperKey
###############################################################################

# Remap Caps Lock (2 = Hyper key)
defaults write com.knollsoft.Hyperkey capsLockRemapped -int 2
# Enable key remapping
defaults write com.knollsoft.Hyperkey keyRemap -int 1
# Launch at login
defaults write com.knollsoft.Hyperkey launchOnLogin -int 1
# Enable quick HyperKey (Escape on tap)
defaults write com.knollsoft.Hyperkey executeQuickHyperKey -int 1
# Quick HyperKey maps to Escape (keycode 53)
defaults write com.knollsoft.Hyperkey quickHyperKeycode -int 53
# Hyper modifier flags (Ctrl+Opt+Shift+Cmd)
defaults write com.knollsoft.Hyperkey hyperFlags -int 1966080

###############################################################################
# Stats (menu bar system monitor)
###############################################################################

# Launch at login
defaults write eu.exelban.Stats LaunchAtLoginNext -int 1
# CPU: show label + line chart
defaults write eu.exelban.Stats CPU_widget -string "label,line_chart"
defaults write eu.exelban.Stats CPU_line_chart_color -string "utilization"
# RAM: show line chart + label
defaults write eu.exelban.Stats RAM_widget -string "line_chart,label"
defaults write eu.exelban.Stats RAM_line_chart_color -string "utilization"
# Network: show chart + label
defaults write eu.exelban.Stats Network_widget -string "network_chart,label"
# Disk: show bar chart + label
defaults write eu.exelban.Stats Disk_widget -string "bar_chart,label"
# Hide unused modules
defaults write eu.exelban.Stats Battery_widget -string ""
defaults write eu.exelban.Stats Bluetooth_widget -string ""
defaults write eu.exelban.Stats GPU_widget -string ""
defaults write eu.exelban.Stats Sensors_widget -string ""
defaults write eu.exelban.Stats Clock_widget -string ""

###############################################################################
# Window management (AeroSpace + Sketchybar)
###############################################################################

# macOS native menu bar — restore it (a-bar provides workspace indicators)
defaults write NSGlobalDomain _HIHideMenuBar -bool false

# Drag windows by holding Ctrl+Cmd and dragging any part (not just title bar)
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# Disable window opening animations (e.g. Chrome new-window bounce)
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

###############################################################################
# Restart affected apps
###############################################################################

for app in Dock Finder; do
  killall "$app" &>/dev/null || true
done

echo "Done. You may need to restart HyperKey and AeroSpace manually. Launch AeroSpace first to grant Accessibility permission."
