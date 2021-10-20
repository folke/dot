#!/usr/bin/env fish

function die
  echo "[error] $argv" >&2
  exit 1
end

function visibility
	xwininfo -id $argv[1] 2> /dev/null | gawk '/Map State/ {print $3}'
end

function run
  kitty ~ --title scratchpad -1 --instance-group scratchpad -o background_opacity=0.9 &
  set kpid (jobs -lp)

  # Wait till we have a window
  for i in (seq 200)
    set wid (xdotool search --pid $kpid)
    wmctrl -ir $wid -b add,above,skip_taskbar
    set vis (visibility $wid)
    if [ -n "$wid" ] && [ "$vis" = IsViewable ]
      echo $wid
      xdotool windowunmap --sync $wid
      wmctrl -ir $wid -b add,above,skip_taskbar
      return
    end
    sleep 0.01
  end
  die "Could not get window id"
end

set widfile "$XDG_RUNTIME_DIR/kitty-quake"

set geom (xdotool getdisplaygeometry)
set height 600
set width $geom[1]

set wid

if [ -f "$widfile" ]
  set wid (cat "$widfile")
  if [ -n "$wid" ]
    xprop -id $wid
    or set wid ""
  end
end

set show 1

if [ -z "$wid" ]
  set wid (run)
  echo $wid > $widfile
else
  if [ (visibility $wid) = IsViewable ]
    set show 0
  end
end

echo "wid: $wid"
#sleep 3
# xdotool set_desktop_for_window "$wid" (xdotool get_desktop)

if [ $show -eq 1 ]
  xdotool windowmap "$wid"
  wmctrl -ir $wid -b add,above,skip_taskbar
  xdotool  windowmove "$wid" "0" "39" \
    windowsize "$wid" "$width" "$height"
    # wmctrl -ir $wid -b add,above,skip_taskbar
  xdotool windowactivate "$wid"
  #xdotool behave $wid blur exec ~/bin/kitty-quake.fish &
  #set blurpid (jobs -lp)
else
  xdotool windowunmap "$wid"
end
