#!/usr/bin/env python

import json
from os.path import expanduser

def alpha(rgb, opacity):
  r = int(rgb[1:3], 16)
  g = int(rgb[3:5], 16)
  b = int(rgb[5:], 16)
  bg = (1 - opacity) * 255

  r = bg + opacity * r
  g = bg + opacity * g
  b = bg + opacity * b

  return "#" + hex(int(r))[2:] + "" + hex(int(g))[2:] + "" + hex(int(b))[2:]

print("[colors]")

with open(expanduser('~/.cache/wal/colors.json')) as json_file:
    data = json.load(json_file)
    for color in {**data['colors'], **data['special']}.items():
      print(color[0] + " = " + color[1])
      for a in reversed(range(40, 100, 5)):
        print(color[0] + "_" + str(a) + " = " + alpha(color[1], a / 100.0))
      print()
    
    # Add background alpha colors
    for a in reversed(range(10, 100, 5)):
      print("alpha_" + str(a) + " = #" + hex(int(255 * a / 100.0))[2:] + data['special']['background'][1:])
    print()