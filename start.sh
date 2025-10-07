#!/usr/bin/env bash
# notification daemon
dunst &

# copy/paste to wine apps
wl-paste -t text -w xclip -selection clipboard &

# wallpaper
swww init
swww img ~/.config/hypr/sand.png

# laucher bar
pkill waybar
waybar -c ~/.config/hypr/waybar.conf -s ~/.config/hypr/waybar.style &

lxqt-policykit-agent
