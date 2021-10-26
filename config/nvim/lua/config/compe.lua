-- local util = require("util")

vim.o.completeopt = "menuone,noselect"

-- Setup nvim-cmp.
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `luasnip` user.
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  formatting = {
    format = require("config.lsp.kind").cmp_format(),
  },
  documentation = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  experimental = {
    ghost_text = {
      hl_group = "LineNr",
    },
  },
})

-- require("compe").setup({
--   enabled = true,
--   autocomplete = true,
--   debug = false,
--   min_length = 1,
--   preselect = "always", -- changed to "enable" to prevent auto select
--   throttle_time = 80,
--   source_timeout = 200,
--   incomplete_delay = 400,
--   max_abbr_width = 100,
--   max_kind_width = 100,
--   max_menu_width = 100,
--   documentation = {
--     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
--   },

--   source = {
--     path = true,
--     buffer = true,
--     calc = true,
--     nvim_lsp = true,
--     nvim_lua = false,
--     vsnip = false,
--     luasnip = true,
--     treesitter = false,
--     emoji = true,
--     spell = true,
--   },
-- })

-- util.inoremap("<C-Space>", "compe#complete()", { expr = true })
-- util.inoremap("<C-e>", "compe#close('<C-e>')", { expr = true })

-- local function complete()
--   if vim.fn.pumvisible() == 1 then
--     return vim.fn["compe#confirm"]({ keys = "<cr>", select = true })
--   else
--     return require("nvim-autopairs").autopairs_cr()
--   end
-- end

-- util.imap("<CR>", complete, { expr = true })
-- vim.cmd([[autocmd User CompeConfirmDone silent! lua vim.lsp.buf.signature_help()]])
