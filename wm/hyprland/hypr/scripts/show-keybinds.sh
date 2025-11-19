#!/bin/bash
# Simple keybinds list for wofi

KEYBINDS=$(
  cat <<EOF
Super (tap) - Launcher (wofi)
Super + Enter - Terminal (Alacritty)
Ctrl + Alt + T - Terminal (Alacritty)
Super + Q - Close window
Super + F - Fullscreen
Super + V - Toggle floating
Super + J - Toggle split layout
Super + P - Pseudo-tile
Super + D - Overview (hycov)
Super + H - Show this cheatsheet
Super + [1-0] - Switch workspace
Super + Shift + [1-0] - Move window to workspace
Super + Arrow keys - Focus direction
Super + Ctrl + Arrow keys - Resize window
Super + mouse drag - Move/Resize window
Super + Shift + E - Exit Hyprland
Super + Shift + R - Restart Hyprland
EOF
)

echo "$KEYBINDS" | wofi --dmenu --lines 20 --width 600 --height 400 --prompt "Keybinds Cheatsheet"
