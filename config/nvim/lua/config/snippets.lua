local util = require("util")

--- <tab> to jump to next snippet's placeholder
local function on_tab()
  if vim.fn.call("vsnip#available", { 1 }) == 1 then
    return util.t("<Plug>(vsnip-expand-or-jump)")
  else
    return util.t("<Tab>")
  end
end

--- <s-tab> to jump to next snippet's placeholder
local function on_s_tab()
  if vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
    return util.t("<Plug>(vsnip-jump-prev)")
  else
    return util.t("<S-Tab>")
  end
end

util.imap("<Tab>", on_tab, { expr = true })
util.smap("<Tab>", on_tab, { expr = true })
util.imap("<S-Tab>", on_s_tab, { expr = true })
util.smap("<S-Tab>", on_s_tab, { expr = true })
