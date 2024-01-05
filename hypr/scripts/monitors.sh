#!/usr/bin/env bash

handle() {
	case $1 in
	monitoradded*)
		# Check if there are 2 or more monitors
		if [ $(hyprctl monitors -j | jq length) -ge 2 ]; then
			active_workspace=hyprctl activeworkspace -j | jq '.id'
			hyprctl keyword monitor eDP-1, disable
			hyprctl dispatch workspace $active_workspace
		fi
		;;
	monitorremoved*)
		if [ $(hyprctl monitors -j | jq length) -eq 0 ]; then
			active_workspace=hyprctl activeworkspace -j | jq '.id'
			hyprctl keyword monitor eDP-1,2560x1600@90,0x0,2
			hyprctl dispatch workspace $active_workspace
		fi
		;;
	esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
