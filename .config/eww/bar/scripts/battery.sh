#!/usr/bin/env bash

function get_battery_info() {
	battery_information=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
	battery_percentage=$(echo $battery_information | grep -oP 'percentage:\s+\K\d+' | head -n1)
	battery_state=$(echo $battery_information | grep -oP 'state:\s+\K\w+' | head -n1)

	if [ "$battery_state" == "discharging" ]; then
		if [ "$battery_percentage" -gt 99 ]; then
			echo '{"icon": "󰁹", "style":"color:#a6d189"}'
		elif (($battery_percentage > 90 && $battery_percentage <= 99)); then
			echo '{"icon": "󰂂", "style":"color:#a6d189"}'
		elif (($battery_percentage > 80 && $battery_percentage <= 90)); then
			echo '{"icon": "󰂁", "style":"color:#a6d189"}'
		elif (($battery_percentage > 70 && $battery_percentage <= 80)); then
			echo '{"icon": "󰂀", "style":"color:#a6d189"}'
		elif (($battery_percentage > 60 && $battery_percentage <= 70)); then
			echo '{"icon": "󰁿", "style":"color:#e5c890"}'
		elif (($battery_percentage > 50 && $battery_percentage <= 60)); then
			echo '{"icon": "󰁾", "style":"color:#e5c890"}'
		elif (($battery_percentage > 40 && $battery_percentage <= 50)); then
			echo '{"icon": "󰁽", "style":"color:#e5c890"}'
		elif (($battery_percentage > 30 && $battery_percentage <= 40)); then
			echo '{"icon": "󰁼", "style":"color:#e78284"}'
		elif (($battery_percentage > 20 && $battery_percentage <= 30)); then
			echo '{"icon": "󰁻", "style":"color:#e78284"}'
		elif (($battery_percentage > 10 && $battery_percentage <= 20)); then
			echo '{"icon": "󰁺", "style":"color:#e78284"}'
		elif ("$battery_percentage" -lt 11); then
			echo '{"icon": "󰂎", "style":"color:#e78284"}'
		fi
	else
		if [ "$battery_percentage" -gt 99 ]; then
			echo '{"icon": "󰂅", "style":"color:#a6d189"}'
		elif (($battery_percentage > 90 && $battery_percentage <= 99)); then
			echo '{"icon": "󰂋", "style":"color:#a6d189"}'
		elif (($battery_percentage > 80 && $battery_percentage <= 90)); then
			echo '{"icon": "󰂊", "style":"color:#a6d189"}'
		elif (($battery_percentage > 70 && $battery_percentage <= 80)); then
			echo '{"icon": "󰢞", "style":"color:#a6d189"}'
		elif (($battery_percentage > 60 && $battery_percentage <= 70)); then
			echo '{"icon": "󰂉", "style":"color:#e5c890"}'
		elif (($battery_percentage > 50 && $battery_percentage <= 60)); then
			echo '{"icon": "󰢝", "style":"color:#e5c890"}'
		elif (($battery_percentage > 40 && $battery_percentage <= 50)); then
			echo '{"icon": "󰂈", "style":"color:#e5c890"}'
		elif (($battery_percentage > 30 && $battery_percentage <= 40)); then
			echo '{"icon": "󰂇", "style":"color:#e78284"}'
		elif (($battery_percentage > 20 && $battery_percentage <= 30)); then
			echo '{"icon": "󰂆", "style":"color:#e78284"}'
		elif (($battery_percentage > 10 && $battery_percentage <= 20)); then
			echo '{"icon": "󰢜", "style":"color:#e78284"}'
		elif ("$battery_percentage" -lt 11); then
			echo '{"icon": "󰢟", "style":"color:#e78284"}'
		fi
	fi
}

get_battery_info

while read -r event; do
	get_battery_info
done < <(upower --monitor)
