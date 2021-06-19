local lspconfig = require("lspconfig")

if vim.lsp.setup then
  vim.lsp.setup({
    floating_preview = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
    diagnostics = {
      signs = { error = " ", warning = " ", hint = " ", information = " " },
      display = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
    },
    completion = {
      kind = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = "了 ",
        EnumMember = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = "ﰮ ",
        Keyword = " ",
        Method = "ƒ ",
        Module = " ",
        Property = " ",
        Snippet = "﬌ ",
        Struct = " ",
        Text = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
    },
  })
else
  -- require("config.lsp.saga")
  require("config.lsp.diagnostics")
  require("config.lsp.kind").setup()
end

local function on_attach(client, bufnr)
  require("config.lsp.formatting").setup(client, bufnr)
  require("config.lsp.keys").setup(client, bufnr)
  require("config.lsp.completion").setup(client, bufnr)
  require("config.lsp.highlighting").setup(client)

  -- TypeScript specific stuff
  if client.name == "typescript" or client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end
end

local lua_cmd = {
  "/Users/folke/projects/lua-language-server/bin/macOS/lua-language-server",
  "-E",
  "-e",
  "LANG=en",
  "/Users/folke/projects/lua-language-server/main.lua",
}
lua_cmd = { "lua-language-server" }

local servers = {
  pyright = {},
  bashls = {},
  tsserver = {},
  cssls = { cmd = { "css-languageserver", "--stdio" } },
  rnix = {},
  jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
  html = { cmd = { "html-languageserver", "--stdio" } },
  clangd = {},
  sumneko_lua = require("lua-dev").setup({
    -- library = { plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" } },
    lspconfig = { cmd = lua_cmd },
  }),
  efm = require("config.lsp.efm").config,
  vimls = {},
  -- tailwindcss = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

require("null-ls").setup({ on_attach = on_attach, capabilities = capabilities })
require("nvim-lsp-json").setup()

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config))
  local cfg = lspconfig[server]
  if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
    vim.notify(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
  end
end
