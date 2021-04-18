vim.o.completeopt = "menuone,noselect"

require("compe").setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "always", -- changed to "enable" to prevent auto select
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    treesitter = false
  }
})

-- inoremap <silent><expr> <C-Space> compe#complete()
-- inoremap <silent><expr> <CR>      compe#confirm('<CR>')
-- inoremap <silent><expr> <C-e>     compe#close('<C-e>')
-- inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
-- inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { silent = true, expr = true })
-- vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", { silent = true, expr = true })

local Helper = require "compe.helper"
Helper.convert_lsp_orig = Helper.convert_lsp
Helper.convert_lsp = function(args)
  local response = args.response or {}
  local items = response.items or response
  for _, item in ipairs(items) do
    -- 2: method
    -- 3: function
    -- 4: constructor
    if item.insertText == nil and (item.kind == 2 or item.kind == 3 or item.kind == 4) then
      item.insertText = item.label .. "(${1})"
      item.insertTextFormat = 2
    end
  end
  return Helper.convert_lsp_orig(args)
end

-- vim.cmd [[autocmd User CompeConfirmDone :Lspsaga signature_help]]
