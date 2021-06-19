local util = require("util")

local M = {}

M.autoformat = true

function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    util.info("enabled format on save", "Formatting")
  else
    util.warn("disabled format on save", "Formatting")
  end
end

function M.format()
  if M.autoformat then
    vim.lsp.buf.formatting_sync()
  end
end

function M.setup(client, buf)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  local efm_formatted = require("config.lsp.efm").formatted_languages
  local null_formatted = {}

  local enable = false
  if efm_formatted[ft] then
    enable = client.name == "efm"
  elseif null_formatted[ft] then
    enable = client.name == "null-ls"
  else
    enable = not (client.name == "efm" or client.name == "null-ls")
  end

  client.resolved_capabilities.document_formatting = enable
  -- format on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("config.lsp.formatting").format()
      augroup END
    ]])
  end
end

return M
