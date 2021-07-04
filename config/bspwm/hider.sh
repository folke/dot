#!/bin/bash

popline() (
  LC_CTYPE=C
  l=$(
    tail -n "${2:-1}" "$1"
    echo t
  )
  l=${l%t}
  truncate -s "-${#l}" "$1"
  printf %s "$l"
)

# if the focused window is floating, then hide it
if [ "$1" != "unhide" ] && [ -n "$(bspc query -N -n focused.floating)" ]; then
  bspc query -N -n >>~/.config/bspwm/hider.log
  bspc node -g hidden=on
else
  last=$(popline ~/.config/bspwm/hider.log)
  [ -n "$last" ] && bspc node "$last" -g hidden=off -f
fi
