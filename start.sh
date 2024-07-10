#!/usr/bin/env bash

# wallpaper
swww init
swww img ~/.config/hypr/sand.png

# laucher bar
pkill waybar
waybar -c ~/.config/hypr/waybar.conf -s ~/.config/hypr/waybar.style &

lxqt-policykit-agent

# clipboard
dunst &
