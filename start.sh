#!/usr/bin/env bash

# wallpaper
swww init
swww img ~/.config/hypr/nebula.png

# laucher bar
waybar -c ~/.config/hypr/waybar.conf -s ~/.config/hypr/waybar.style &

# clipboard
dunst &
