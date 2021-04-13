local lspconfig = require("lspconfig")
local wk = require("whichkey_setup")
local util = require("util")

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

-- Automatically update diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  function(...)
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 { underline = true, update_in_insert = false })(...)
    pcall(vim.lsp.diagnostic.set_loclist, { open_loclist = false })
  end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true, bufnr = bufnr }

  local keymap = {
    c = {
      name = "+code",
      r = { "<cmd>lua require('lspsaga.rename').rename()<CR>", "Rename" },
      a = { "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", "Code Action" },
      d = { "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", "Line Diagnostics" },
      l = {
        name = "+lsp",
        i = { "<cmd>LspInfo<cr>", "Lsp Info" },
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
        l = {
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
          "List Folders"
        }
      }
    },
    x = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "List Errors" }
  }

  -- TypeScript specific stuff
  if client.name == "typescript" then
    require("nvim-lsp-ts-utils").setup {
      disable_commands = false,
      enable_import_on_completion = false,
      import_on_completion_timeout = 5000
    }
    keymap.c.o = { "<cmd>:TSLspOrganize<CR>", "Organize Imports" }
    keymap.c.R = { "<cmd>:TSLspRenameFile<CR>", "Rename File" }
  end

  local keymap_visual = {
    c = {
      name = "+code",
      a = { ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", "Code Action" }
    }
  }

  local keymap_goto = {
    name = "+goto",
    r = { "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "References" },
    d = { "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", "Peek Definition" },
    D = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
    s = { "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", "Signature Help" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
    I = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
    t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" }
  }

  util.nmap("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  util.nmap("<CR>", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  util.nmap("[d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
  util.nmap("]d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    keymap.c.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
  elseif client.resolved_capabilities.document_range_formatting then
    keymap_visual.c.f = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format Range" }
  end

  wk.register_keymap("leader", keymap, { noremap = true, silent = true, bufnr = bufnr })
  wk.register_keymap("visual", keymap_visual, { noremap = true, silent = true, bufnr = bufnr })
  wk.register_keymap("g", keymap_goto, { noremap = true, silent = true, bufnr = bufnr })

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
