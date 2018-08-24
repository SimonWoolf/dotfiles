#!/bin/sh

# Sets the primary monitor, and restarts i3, on lid open and awake
#
# This is called by:
#
# - /etc/acpi/events/lid (run when lid is opened)
#event=button/lid LID open
#action=/home/simon/dev/dotfiles/laptop-primary.sh
#
# - /etc/acpi/events/battery (the only event triggered by awaking from suspend)
#event=battery.*
#action=/home/simon/dev/dotfiles/laptop-primary.sh


export XAUTHORITY=/home/simon/.Xauthority
export DISPLAY=:0

xrandr --output eDP-1 --primary

i3-msg restart
