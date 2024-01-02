#!/usr/bin/env bash
hyprctl --batch 'keyword windowrulev2 workspace 3 silent, class:(firefox) ; dispatch exec firefox'
hyprctl --batch 'keyword windowrulev2 workspace 2 silent, class:(kitty) ; dispatch exec kitty'
