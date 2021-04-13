local util = require "util"

util.nmap("<C-_>", "<Plug>kommentary_line_default", { noremap = false })
util.vmap("<C-_>", "<Plug>kommentary_visual_default", { noremap = false })

