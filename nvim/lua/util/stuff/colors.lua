local M = {}

M.ns = vim.api.nvim_create_namespace("lsp.colors")

---@type table<string,true>
M.hl = {}

---@param hex string
function M.get_hl(hex)
  local hl = "LspColor" .. hex:sub(2)
  if not M.hl[hl] then
    M.hl[hl] = true
    vim.api.nvim_set_hl(0, hl, { bg = hex })
  end
  return hl
end

function M.update(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
  vim.lsp.buf_request(buf, "textDocument/documentColor", params, function(err, colors)
    if err then
      return
    end
    for _, c in ipairs(colors) do
      local color = c.color
      color.red = math.floor(color.red * 255 + 0.5)
      color.green = math.floor(color.green * 255 + 0.5)
      color.blue = math.floor(color.blue * 255 + 0.5)
      local hex = string.format("#%02x%02x%02x", color.red, color.green, color.blue)

      local offset_encoding = vim.lsp.util._get_offset_encoding(buf)
      local start_row = c.range.start.line
      local start_col = vim.lsp.util._get_line_byte_from_position(buf, c.range.start, offset_encoding)
      local end_row = c.range["end"].line
      local end_col = vim.lsp.util._get_line_byte_from_position(buf, c.range["end"], offset_encoding)

      vim.api.nvim_buf_set_extmark(buf, M.ns, start_row, start_col, {
        end_row = end_row,
        end_col = end_col,
        hl_group = M.get_hl(hex),
        priority = 5000,
      })
    end
  end)
end

return M
