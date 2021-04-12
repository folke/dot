local lspconfig = require("lspconfig")

-- Format On Save
_G.formatting = function()
  vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
end

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then vim.cmd [[noautocmd :update]] end
  end
end

local on_attach = function(client, bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  local opts = { noremap = true, silent = true }
  map("n", "gd", "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
  map("n", "gD", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- map("n", "gi", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  map("n", "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map("n", "gs", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)

  map("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  map("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  map("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
      opts)

  map("n", "<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  map("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  map("n", "<Leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  map("n", "<Leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    map("n", "<Leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    map("n", "<Leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- format on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
    vim.cmd [[augroup END]]
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=Grey30
      hi LspReferenceText cterm=bold ctermbg=red guibg=Grey30
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=Grey30
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local on_attach_no_format = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  on_attach(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local defaults = { on_attach = on_attach, capabilities = capabilities }

local servers = {
  bash = {},
  typescript = { on_attach = on_attach_no_format },
  css = { on_attach = on_attach_no_format },
  html = { on_attach = on_attach_no_format },
  lua = require("config.lsp.lua"),
  efm = require("config.lsp.efm"),
  tailwindcss = {},
  json = { on_attach = on_attach_no_format }
}

local installer = require("lspinstall")
installer.setup()

local installed = {}
for _, server in pairs(installer.installed_servers()) do installed[server] = true end

for server, config in pairs(servers) do
  if not installed[server] then error("LSP server missing \"" .. server .. "\"") end
  lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
end
