#!/bin/sh
setxkbmap gb && xmodmap ~/.XmodmapForTrulyErgonomic
killall python2 && quicktile.py --daemonize &
