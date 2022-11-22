local M = {
  module = "luasnip",
  requires = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}

function M.config()
  local util = require("util")
  local luasnip = require("luasnip")
  require("neogen")

  luasnip.config.setup({
    history = true,
    enable_autosnippets = true,
    -- Update more often, :h events for more info.
    -- updateevents = "TextChanged,TextChangedI",
  })

  --- <tab> to jump to next snippet's placeholder
  local function on_tab()
    return luasnip.jump(1) and "" or util.t("<Tab>")
  end

  --- <s-tab> to jump to next snippet's placeholder
  local function on_s_tab()
    return luasnip.jump(-1) and "" or util.t("<S-Tab>")
  end

  -- vim.keymap.set("i", "<Tab>", on_tab, { expr = true })
  -- vim.keymap.set("s", "<Tab>", on_tab, { expr = true })
  -- vim.keymap.set("i", "<S-Tab>", on_s_tab, { expr = true })
  -- vim.keymap.set("s", "<S-Tab>", on_s_tab, { expr = true })

  vim.cmd([[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
]])
end

return M
