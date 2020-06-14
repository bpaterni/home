#!/bin/bash
BG="/home/bpaterni/.backgrounds/debian/debian-dual-3840x1080.jpg"

#xrandr --output DisplayPort-0 --mode 2560x1440
xrandr --output DisplayPort-0 --mode 2560x1440 --output HDMI-A-0 --mode 2560x1440 --primary --left-of DisplayPort-0 
#xrandr --output DisplayPort-0 --mode 2560x1440 --output HDMI-A-0 --primary --left-of DisplayPort-0 

xrdb -merge ~/.Xresources

# Start URxvt daemon so we can quickly open other clients
#urxvtd -q -o -f

xset r rate 250 25 &
xset s off -dpms &
hsetroot -fill $BG &
xsetroot -cursor_name left_ptr &

#start-pulseaudio-x11 &

rm -f ~/.xmonad/xmonad.state

redshift &

exec /usr/bin/xmonad
