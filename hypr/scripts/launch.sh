#!/usr/bin/env bash
hyprctl setcursor 'Bibata-Modern-Ice' 24
hyprctl --batch 'keyword windowrulev2 workspace 3 silent, class:(firefox) ; dispatch exec firefox ; keyword windowrulev2 workspace 3, class:(firefox);'
hyprctl --batch 'keyword windowrulev2 workspace 2 silent, class:(kitty) ; dispatch exec kitty ; keyword windowrulev2 workspace 2, class:(kitty);'
