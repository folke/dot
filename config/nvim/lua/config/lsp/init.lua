local lspconfig = require("lspconfig")

require("config.lsp.diagnostics")

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
  html = {},
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
  if not installed[server] then
    error('LSP server missing "' .. server .. '"')
  end
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config))
end
