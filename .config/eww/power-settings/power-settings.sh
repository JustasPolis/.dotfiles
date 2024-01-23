close_window() {
	if [[ $(eww get power-settings-window-open) == "true" ]]; then
		eww close power-settings-window
		eww update power-settings-window-open=false
	fi
}

if [ "$1" = "close-window" ]; then
	close_window
fi



