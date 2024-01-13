#!/usr/bin/env bash

external_monitor_connected=$(hyprctl monitors -j | jq -e 'map(.name == "DP-1" or .name == "DP-2") | any')

if $external_monitor_connected; then
	hyprctl keyword monitor eDP-1, disable
fi

handle() {
	result=$(hyprctl activeworkspace -j | jq '.id')
	case $1 in
	'monitoradded>>DP-1')
		echo "monitor DP1 added"
		hyprctl keyword monitor eDP-1, disable
		;;
	'monitoradded>>DP-2')
		echo "monitor DP2 added"
		hyprctl keyword monitor eDP-1, disable
		;;
	'monitorremoved>>DP-1')
		hyprctl keyword monitor eDP-1,2560x1600@90,auto,2
		echo "monitor DP1 removed"
		;;
	'monitorremoved>>DP-2')
		hyprctl keyword monitor eDP-1,2560x1600@90,auto,2
		echo "monitor dp2 removed"
		;;
	'monitoradded>>eDP-1')
		echo "monitor edp-1 added"
		;;
	'monitorremoved>>eDP-1')
		echo "monitor edp-1 removed"
		;;
	esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
