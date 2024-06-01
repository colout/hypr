# https://github.com/hyprwm/Hyprland/issues/1510
WIN_CLASS=dropterm
EXEC_CMD="kitty --class=${WIN_CLASS}"
TOGGLE=/tmp/droptoggle
DROPTERM=kitty-dropdown

HEIGHT='40'
WIDTH='80'
X_POS=$(( 50 - ${WIDTH} / 2 ))
ACTIVE_WORKSPACE=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
PID=$(hyprctl -j clients | jq -r ".[] | select(.class == \"$WIN_CLASS\") | .pid")
echo ${PID}

function disable_dropdown {
  hyprctl --batch " \
    dispatch movetoworkspacesilent special:${WIN_CLASS},pid:${PID}; \
    " 
}

function enable_dropdown {
  hyprctl --batch " \
    dispatch movewindowpixel exact ${X_POS}% 0%,pid:${PID}; \
    " 
  sleep 1

  hyprctl --batch " \
    dispatch resizewindowpixel exact ${WIDTH}% ${HEIGHT}%,pid:${PID}; \
    dispatch movetoworkspace ${ACTIVE_WORKSPACE},pid:${PID}; \
    " 
}

# First, make sure the terminal is running...
if hyprctl clients | grep "class: ${WIN_CLASS}" ; then
  echo "Kitty already running"  

else
  hyprctl --batch " \
    dispatch exec [ float ] ${EXEC_CMD}; \
    "
  sleep .5
  enable_dropdown
fi


# If the terminal is in a special workspace, it's hidden
if hyprctl -j clients | jq -r '.[] | select(.class == "dropterm") | .workspace.name' | grep "^special:${WIN_CLASS}$"; then
  echo "hidden"
  enable_dropdown
else
  echo "open"
  disable_dropdown
fi


#  hyprctl --batch "dispatch closewindow ${WIN_CLASS};"
#  hyprctl --batch "dispatch movetoworkspacesilent special:${WIN_CLASS},${WIN_CLASS};" 
	#hyprctl --batch "dispatch movewindowpixel 0 -500,$WIN_CLASS; dispatch pin $WIN_CLASS; dispatch cyclenext"

#  dispatch movewindowpixel 0 -500, ${WIN_CLASS};"

#    dispatch resizewindowpixel exact ${WIDTH} ${HEIGHT},${WIN_CLASS}; \
    
#    dispatch resizeactive exact ${WIDTH} ${HEIGHT}; \


exit


if [ -f "$TOGGLE" ]; then
    #Hide terminal and unpin
	hyprctl --batch "dispatch movewindowpixel 0 -500,$DROPTERM; dispatch pin $DROPTERM; dispatch cyclenext"
	rm $TOGGLE
else
    #Show terminal and pin
    hyprctl --batch "dispatch movewindowpixel 0 500,$DROPTERM; dispatch pin $DROPTERM; dispatch focuswindow $DROPTERM"
    touch $TOGGLE
fi
