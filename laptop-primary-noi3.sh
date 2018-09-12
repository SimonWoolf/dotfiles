#!/bin/sh
export XAUTHORITY=/home/simon/.Xauthority
export DISPLAY=:0

sleep 1
xrandr --output eDP-1 --primary
