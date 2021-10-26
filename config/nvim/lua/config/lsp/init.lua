local util = require("util")
local lspconfig = require("lspconfig")

require("config.lsp.diagnostics")
require("config.lsp.kind").setup()

local function on_attach(client, bufnr)
  require("config.lsp.formatting").setup(client, bufnr)
  require("config.lsp.keys").setup(client, bufnr)
  -- require("config.lsp.completion").setup(client, bufnr)
  require("config.lsp.highlighting").setup(client)

  -- TypeScript specific stuff
  if client.name == "typescript" or client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end
end

local lua_cmd = { "lua-language-server" }

local servers = {
  pyright = {},
  bashls = {},
  dockerls = {},
  tsserver = {},
  cssls = { cmd = { "css-languageserver", "--stdio" } },
  rnix = {},
  jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
  html = { cmd = { "html-languageserver", "--stdio" } },
  clangd = {},
  ["null-ls"] = {},
  sumneko_lua = {
    cmd = lua_cmd,
  },
  efm = require("config.lsp.efm").config,
  vimls = {},
  -- tailwindcss = {},
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

require("workspace").setup()
require("lua-dev").setup()
require("config.lsp.null-ls").setup()

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }, config))
  local cfg = lspconfig[server]
  if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
    util.error(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
  end
end
