#!/usr/bin/env bash

external_monitor_connected=$(hyprctl monitors -j | jq -e 'map(.name == "DP-1" or .name == "DP-2") | any')

if $external_monitor_connected; then
	hyprctl keyword monitor eDP-1, disable
fi

handle() {
	echo $1
	case $input in
	'monitoradded>>eDP-1')
		echo "Matched eDP1"
		;;
	'monitoradded>>DP-1')
		hyprctl keyword monitor eDP-1, disable
		;;
	'monitoradded>>DP-2')
		hyprctl keyword monitor eDP-1, disable
		;;
	'monitorremoved>>DP-1')
		hyprctl keyword monitor eDP-1,2560x1600@90,0x0,2
		;;
	'monitorremoved>>DP-2')
		hyprctl keyword monitor eDP-1,2560x1600@90,0x0,2
		;;
	'monitorremoved>>eDP-1')
		echo "Matched DP1"
		;;
	esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
