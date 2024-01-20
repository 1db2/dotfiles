#!/bin/bash

killall -q polybar
polybar mainbar 2>&1 | tee -a /tmp/polybar.log & disown
