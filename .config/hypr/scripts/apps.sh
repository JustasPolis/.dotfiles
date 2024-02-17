#!/usr/bin/env bash

entries="Firefox Celluloid Transmission Kitty Foliate"

pwr=$(printf '%s\n' $entries | wofi --dmenu | awk '{print tolower($1)}')

case $pwr in
transmission)
	hyprctl dispatch exec transmission-gtk
	;;
firefox)
	hyprctl dispatch exec firefox
	;;
celluloid)
	hyprctl dispatch exec celluloid
	;;
kitty)
	hyprctl dispatch exec kitty
	;;
foliate)
	hyprctl dispatch exec GTK_THEME=rose-pine-gtk foliate
	;;
esac
