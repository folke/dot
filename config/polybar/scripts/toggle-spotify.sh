#!/bin/bash

for wid in $(xdotool search --class spotify); do
  bspc node $wid --flag hidden -f
done