#!/bin/sh
setxkbmap gb
xmodmap ~/.XmodmapForTrulyErgonomic
killall python2
echo `ps x | grep python2`
nohup /usr/local/bin/quicktile.py --daemonize &
echo `ps x | grep python2`
