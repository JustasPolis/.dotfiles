#!/usr/bin/env bash

command=$(ddcutil --bus 16 --skip-ddc-checks --enable-dynamic-sleep  getvcp 10)

extracted_value=$(echo "$command" | grep -oP 'current value =\s*\K\d+')

if [ -n "$extracted_value" ]; then
  echo 30.0
fi
