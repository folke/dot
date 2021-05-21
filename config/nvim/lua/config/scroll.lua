require("neoscroll").setup({})
local map = {}

local speed = 2

local function t(v)
  return tostring(math.ceil(v / speed))
end

-- Syntax: t[keys] = {function, {function arguments}}
map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", t(8) } }
map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", t(8) } }
map["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", t(7) } }
map["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", t(7) } }
map["<C-y>"] = { "scroll", { "-0.10", "false", t(20) } }
map["<C-e>"] = { "scroll", { "0.10", "false", t(20) } }
map["zt"] = { "zt", { t(7) } }
map["zz"] = { "zz", { t(7) } }
map["zb"] = { "zb", { t(7) } }

require("neoscroll.config").set_mappings(map)
