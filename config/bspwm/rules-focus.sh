#!/usr/bin/env bash

#!/bin/bash

# needs jq, chwb, xprop
pgrep -f "bspwm/rules-focus.sh" | grep -v $$ | xargs kill 2>/dev/null

bspc subscribe node_focus | while read -r action monitor_id desktop_id node_id; do
  # echo Action: $action
  # echo Monitor: $monitor_id
  # echo Desktop: $desktop_id
  # echo node_id $node_id
  # bspc query -T -n $node_id

  className=$(bspc query -T -n "$node_id" | jq -r '.client.className')
  instanceName=$(bspc query -T -n "$node_id" | jq -r '.client.instanceName')

  ~/.config/bspwm/rules.sh "$node_id" "$className" "$instanceName"
done
