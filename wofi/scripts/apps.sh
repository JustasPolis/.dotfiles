#!/usr/bin/env bash

entries="Firefox Celluloid Transmission Kitty"

pwr=$(printf '%s\n' $entries | wofi -i --dmenu | awk '{print tolower($2)}')

case $pwr in
Transmission)
	hyprctl dispatch exec transmission-gtk
	;;
Firefox)
	hyprctl dispatch exec firefox
	;;
Celluloid)
	hyprctl dispatch exec celluloid
	;;
Kitty)
	hyprctl dispatch exec kitty
	;;

esac
