#!/usr/bin/env bash

open_power_settings_window() {
	if [[ $(eww get power-settings-window-open) == "false" ]]; then
		eww open power-settings-window
		eww update power-settings-window-open=true
	fi
}

if [ "$1" = "open_power_settings_window" ]; then
	open_power_settings_window
elif [ "$1" = "close" ]; then
	close
fi
