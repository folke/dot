#!/usr/bin/bash

exec &> >(tee -a ~/.cache/bspwm/logs/rules.log)

# General Syntax
#     rule COMMANDS
#
# Commands
#     -a, --add (<class_name>|*)[:(<instance_name>|*)] [-o|--one-shot]
#     [monitor=MONITOR_SEL|desktop=DESKTOP_SEL|node=NODE_SEL] [state=STATE] [layer=LAYER]
#     [split_dir=DIR] [split_ratio=RATIO]
#     [(hidden|sticky|private|locked|marked|center|follow|manage|focus|border)=(on|off)]
#     [rectangle=WxH+X+Y]
#         Create a new rule.
#
#     -r, --remove ^<n>|head|tail|(<class_name>|*)[:(<instance_name>|*)]...
#         Remove the given rules.
#
#     -l, --list
#         List the rules.

wid=$1
class=$2
instance=$3
pid=$(xdotool getwindowpid "$wid")
pname=$(ps -p "$pid" -o comm=)

red=0xef6155
green=0x48b685
yellow=0xfec418
blue=0x06b6ef

echo "[bspwm:external:rules] $pid::$wid::$instance.$class.$pname" >>~/.cache/bspwm/logs/rules.log

# The first window on the desktop gets a split ratio of 0.6
# Unless its a terminal window
# Other windows get the default of 0.5
active=$(bspc query -N -n .local.leaf.!hidden.!floating 2>/dev/null | wc -l)
if [ "$active" -eq 1 ]; then
  echo -n "split_ratio=0.65 "
fi

case "$instance.$class.$pname" in
  scratchpad*) echo "sticky=on state=floating rectangle=1200x600+0+0 border=on center=on" ;;

  code*) echo "desktop=^2" ;;

  Dunst*) echo "border=off" ;;

  # kitty*) echo "state=pseudo_tiled rectangle=1280x800+0+0";;

  keep.google.com.*)
    chwb -c $yellow "$wid"
    echo "state=floating sticky=on"
    ;;

  mail.google.com*)
    chwb -c $red "$wid"
    echo "state=floating sticky=on"
    ;;

  web.whatsapp.com.*)
    chwb -c $green "$wid"
    echo "state=floating sticky=on"
    ;;

  www.messenger.com.*)
    chwb -c $blue "$wid"
    echo "state=floating sticky=on"
    ;;

  *spotify) echo "state=floating sticky=on" ;;

  gjs.Gjs*) echo "state=floating rectangle=1200x800+0+0 center=on" ;;

esac

echo
