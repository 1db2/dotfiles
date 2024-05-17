#!/bin/bash

killall -q polybar
polybar --list-monitors | while IFS=: read -r m n; do
	if grep -q "primary" <<< "$n"; then
		MONITOR="$m" polybar --reload mainbar &
	else
		MONITOR="$m" polybar --reload secondbar &
	fi
done
