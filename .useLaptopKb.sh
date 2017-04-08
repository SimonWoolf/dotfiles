#!/bin/sh
setxkbmap gb -variant colemak
setxkbmap -option "terminate:ctrl_alt_bksp"
xmodmap ~/.XmodmapForLaptopKeyboard
#killall python2
#echo `ps x | grep python2`
#nohup /usr/local/bin/quicktile.py --daemonize &
#echo `ps x | grep python2`
