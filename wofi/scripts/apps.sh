#!/usr/bin/env bash

entries="Firefox Celluloid Transmission Kitty"

pwr=$(printf '%s\n' $entries | wofi -i --dmenu | awk '{print tolower($2)}')

case $pwr in 
    Transmission)
        transmission-gtk
        ;;
    Firefox)
      firefox
        ;;
    Celluloid)
        celluloid
        ;;
  Kitty)
      kitty
        ;;

esac
