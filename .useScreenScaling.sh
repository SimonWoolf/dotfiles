#!/bin/sh
/home/simon/dev/vendor/xrandr/xrandr --output eDP1 --scale 0.5x0.5
xfconf-query -c xsettings -p /Xft/DPI -s 96
xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 25
xfconf-query -c xfwm4 -p /general/title_font -s "DejaVu Sans Bold 10"
sed -i 's/user_pref("layout.css.devPixelsPerPx", "1.[0-9]");/user_pref("layout.css.devPixelsPerPx", "1.0");/' .mozilla/firefox/fuevxjfl.default/prefs.js
