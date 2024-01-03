#!/bin/bash

if [ ! -f "/sys/class/hwmon/$1/$2" ]; then
    echo '{"text": "error", "tooltip": "error", "percentage": 0}'
else
    speed=$(cat "/sys/class/hwmon/$1/$2")
    percentage=0
    if [ "${speed}" -gt 3000 ]; then
        percentage=100
    elif [ "${speed}" -gt 0 ]; then
        percentage=50
    fi
    echo "{\"tooltip\": \"${2}: ${speed}RPM\", \"percentage\": ${percentage}}"
fi
