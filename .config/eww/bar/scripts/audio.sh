#!/usr/bin/env bash
#

function get_audio_information() {
	default_sink_name=$(pactl --format=json info | jq -r '.default_sink_name')
	default_sink=$(pactl --format=json list sinks | jq --arg target "$default_sink_name" '.[] | select(.name == $target)')
	mute_state=$(echo $default_sink | jq -r '.mute')
	front_left_volume=$(echo "$default_sink" | jq -r '.volume."front-left".value_percent' | tr -d '%')
	front_right_volume=$(echo "$default_sink" | jq -r '.volume."front-right".value_percent' | tr -d '%')
	volume=$((($front_left_volume + front_right_volume) / 2))
	if [ "$mute_state" == "false" ]; then
		if (($volume > 70 && $volume <= 100)); then
			echo '{"icon": "󰕾", "style":"color:#99d1db"}'
		elif (($volume > 30 && $volume <= 70)); then
			echo '{"icon": "󰖀", "style":"color:#e5c890"}'
		elif (($volume > 1 && $volume <= 30)); then
			echo '{"icon": "󰕿", "style":"color:#e78284"}'
		else
			echo '{"icon": "󰖁", "style":"color:#626880"}'
		fi
	else
		echo '{"icon": "󰝟", "style":"color:#626880"}'
	fi
}

get_audio_information

while read -r event; do
	if [[ "$event" == *"Event 'change' on sink"* ]]; then
		get_audio_information
	fi
done < <(pactl subscribe)
