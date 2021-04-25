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

return {
  setup = function(client)
    local formatted_languages = require("config.lsp.efm").formatted_languages

    if formatted_languages[client.name] then
      client.resolved_capabilities.document_formatting = false
    end

    -- format on save
    if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
      vim.cmd [[augroup END]]
    end
  end
}
