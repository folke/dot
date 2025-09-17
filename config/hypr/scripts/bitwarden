#!/usr/bin/env bash

# See: https://github.com/hyprwm/Hyprland/issues/3835#issuecomment-2491114463

handle_windowtitlev2() {
  # Description: emitted when a window title changes.
  # Format: `WINDOWADDRESS,WINDOWTITLE`
  windowaddress=${1%,*}
  windowtitle=${1#*,}

  case $windowtitle in
  *"(Bitwarden"*"Password Manager) - Bitwarden"*)
    hyprctl --batch \
      "dispatch setfloating address:0x$windowaddress;" \
      "dispatch resizewindowpixel exact 30% 60%,address:0x$windowaddress;" \
      "dispatch centerwindow"
    ;;
    #   specificwindowtitle) commands;;
  esac
}

handle() {
  # $1 Format: `EVENT>>DATA`
  # example: `workspace>>2`

  event=${1%>>*}
  data=${1#*>>}

  case $event in
  windowtitlev2) handle_windowtitlev2 "$data" ;;
    #   anyotherevent) handle_otherevent "$data";;
  *) echo "unhandled event: $event" ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
