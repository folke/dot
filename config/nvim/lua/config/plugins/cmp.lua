local cmdline = false
local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-emoji",
    { "hrsh7th/cmp-cmdline", enabled = cmdline },
    { "dmitmel/cmp-cmdline-history", enabled = cmdline },
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
}

function M.config()
  vim.o.completeopt = "menuone,noselect"

  -- Setup nvim-cmp.
  local cmp = require("cmp")

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete({}),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "emoji" },
      { name = "neorg" },
    }),
    formatting = {
      format = require("config.plugins.lsp.kind").cmp_format(),
    },
    -- documentation = {
    --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --   winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
    -- },
    experimental = {
      ghost_text = {
        hl_group = "LspCodeLens",
      },
    },
    -- sorting = {
    --   comparators = {
    --     cmp.config.compare.sort_text,
    --     cmp.config.compare.offset,
    --     -- cmp.config.compare.exact,
    --     cmp.config.compare.score,
    --     -- cmp.config.compare.kind,
    --     -- cmp.config.compare.length,
    --     cmp.config.compare.order,
    --   },
    -- },
  })
  if cmdline then
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        -- { name = "noice_popupmenu" },
        { name = "path" },
        { name = "cmdline" },
        -- { name = "cmdline_history" },
      }),
    })
  end
end

return M
