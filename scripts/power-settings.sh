#!/usr/bin/env bash

ac_adapter_status=$(cat /sys/class/power_supply/ACAD/online)

if [[ $ac_adapter_status -eq 1 ]]; then
	# If ACAD/online is 1, set the governor to performance
	sudo cpupower frequency-set --governor performance
	echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
elif [[ $ac_adapter_status -eq 0 ]]; then
	# If ACAD/online is 0, set the governor to powersave
	sudo cpupower frequency-set --governor powersave
	echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
else
	# Handle other cases if needed
	echo "Unexpected value in AC status: $ac_adapter_status"
fi
