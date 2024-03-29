#!/usr/bin/env bash

icon() {
        # not connected
        if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
                echo "󰂲"
        else
                if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]; then
                        #     echo $HOME/.local/icons/bluetooth-on.svg
                        echo "󰂯"
                else
                        # get device alias
                        #    DEVICE=`echo info | bluetoothctl | grep 'Alias:' | awk -F:  '{ print $2 }'`
                        #    BATTERY=`upower -i /org/freedesktop/UPower/devices/headset_dev_33_33_55_33_90_D0 | grep percentage | cut -b 26-28`
                        echo "󰂱"
                fi
        fi
}

state() {
        # not connected
        if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
                #     echo $HOME/.local/icons/bluetooth-off.svg
                echo "Disconnected"
        else
                # connected, but no device
                if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]; then
                        #     echo $HOME/.local/icons/bluetooth-on.svg
                        echo "Connected"
                else
                        # get device alias
                        DEVICE=`echo info | bluetoothctl | grep 'Alias:' | awk -F:  '{ print $2 }'`
                        BATTERY=`upower -i /org/freedesktop/UPower/devices/headset_dev_33_33_55_33_90_D0 | grep percentage | cut -b 26-28`
                        echo "$DEVICE ($BATTERY)"
                fi
        fi
}

if [[ $1 == "-l" ]]; then
        state
elif [[ $1 == "-i" ]]; then
        icon
fi
