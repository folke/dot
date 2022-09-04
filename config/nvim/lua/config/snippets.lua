local util = require("util")
local luasnip = require("luasnip")
require("neogen")

luasnip.config.setup({
  history = false,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

--- <tab> to jump to next snippet's placeholder
local function on_tab()
  return luasnip.jump(1) and "" or util.t("<Tab>")
end

--- <s-tab> to jump to next snippet's placeholder
local function on_s_tab()
  return luasnip.jump(-1) and "" or util.t("<S-Tab>")
end

util.imap("<Tab>", on_tab, { expr = true })
util.smap("<Tab>", on_tab, { expr = true })
util.imap("<S-Tab>", on_s_tab, { expr = true })
util.smap("<S-Tab>", on_s_tab, { expr = true })
