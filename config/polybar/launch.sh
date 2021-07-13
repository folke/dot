#!/usr/bin/env sh

## Add this to your wm startup file.

# Kill other launch scripts
# ps axu | grep "polybar/launch.sh" | awk "{print \$2}" | grep -v $$ | xargs kill 2>/dev/null

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "Polybars killed..."

# Wal Color Generator
#python ~/.config/polybar/scripts/colors.py > ~/.config/polybar/colors.ini
#echo "Colors generated..."

polybar -r -c ~/.config/polybar/config.ini main &

exit

# Launch bar1 and bar2
polybar -r -c ~/.config/polybar/config.ini ws &
polybar -r -c ~/.config/polybar/config.ini music &
polybar -r -c ~/.config/polybar/config.ini tray &

mpid=

while true; do
  # check whether the polybar is still running
  kill -0 "$mpid" 2> /dev/null || mpid=

  if playerctl status 2> /dev/null; then
    echo "[debug] music player running"
    if [ -z "$mpid" ]; then
      echo "[debug] starting music polybar"
      polybar -r -c ~/.config/polybar/config.ini music &
      mpid=$!
    fi
  else
    echo "[debug] music player not running"
    if [ -n "$mpid" ]; then
      echo "[debug] killing music polybar"
      kill "$mpid"
      while kill -0 "$mpid" 2>/dev/null; do sleep 1; done
    fi
  fi
  sleep 1
done


