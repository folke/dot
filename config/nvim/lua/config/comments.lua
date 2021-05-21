local util = require("util")

require("kommentary.config").configure_language("default", { prefer_single_line_comments = true })

util.nmap("<C-_>", "<Plug>kommentary_line_default")
util.vmap("<C-_>", "<Plug>kommentary_visual_default")
