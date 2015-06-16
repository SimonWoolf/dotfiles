#!/bin/sh
setxkbmap gb -variant colemak && xmodmap ~/.XmodmapForLaptopKeyboard
killall python2 && quicktile.py --daemonize &
