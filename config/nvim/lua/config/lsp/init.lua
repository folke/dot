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
  require("config.lsp.saga")
  require("config.lsp.diagnostics")
  require("config.lsp.kind").setup()
end

local function on_attach(client, bufnr)
  require("config.lsp.formatting").setup(client)
  require("config.lsp.keys").setup(client, bufnr)
  require("config.lsp.completion").setup(client, bufnr)
  require("config.lsp.highlighting").setup(client)

  -- TypeScript specific stuff
  if client.name == "typescript" or client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end
end
local servers = {
  python = {},
  bash = {},
  typescript = {},
  css = {},
  php = {},
  html = {},
  cpp = {},
  rnix = {},
  lua = require("lua-dev").setup({ library = { plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" } } }),
  efm = require("config.lsp.efm").config,
  -- tailwindcss = {},
  json = {},
  vim = {},
}

local installer = require("lspinstall")
installer.setup()

local installed = {}
for _, server in pairs(installer.installed_servers()) do
  installed[server] = true
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

for server, config in pairs(servers) do
  print(server)
  if not installed[server] then
    vim.notify('LSP server missing "' .. server .. '"')
  end
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config))
end
