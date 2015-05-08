#!/bin/sh
/home/simon/dev/vendor/xrandr/xrandr --output eDP1 --scale 1.0x1.0
xfconf-query -c xsettings -p /Xft/DPI -s 192
xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 45
xfconf-query -c xfwm4 -p /general/title_font -s "DejaVu Sans Bold 8"
sed -i 's/user_pref("layout.css.devPixelsPerPx", "1.[0-9]");/user_pref("layout.css.devPixelsPerPx", "1.8");/' .mozilla/firefox/fuevxjfl.default/prefs.js
