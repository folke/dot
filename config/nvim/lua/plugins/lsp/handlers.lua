local M = {}

M.hover_orig = vim.lsp.handlers["textDocument/hover"]

function M.setup()
  vim.lsp.handlers["textDocument/hover"] = M.hover
end

---@alias MarkedString string | { language: string; value: string }
---@alias MarkupContent { kind: ('plaintext' | 'markdown'), value: string}
---@alias MarkupContents MarkedString | MarkedString[] | MarkupContent

function M.hover(_, result, ...)
  local notify = require("notify")
  -- M.hover_orig(_, result, ...)
  if not (result and result.contents) then
    notify("No information available")
    return
  end

  ---@type MarkupContents
  local contents = result.contents

  if not vim.tbl_islist(contents) then
    contents = { contents }
  end

  local parts = {}

  for _, content in ipairs(contents) do
    if type(content) == "string" then
      table.insert(parts, content)
    elseif content.language then
      table.insert(parts, ("```%s\n%s\n```"):format(content.language, content.value))
    elseif content.kind == "markdown" then
      table.insert(parts, content.value)
    elseif content.kind == "plaintext" then
      table.insert(parts, ("```\n%s\n```"):format(content.value))
    end
  end

  local text = table.concat(parts, "\n")
  text = text:gsub("\n\n", "\n")
  text = text:gsub("\n%s*\n```", "\n```")
  text = text:gsub("```\n%s*\n", "```\n")

  local lines = vim.split(text, "\n")

  local width = 50
  for _, line in pairs(lines) do
    width = math.max(width, vim.api.nvim_strwidth(line))
  end

  for l, line in ipairs(lines) do
    if line:find("^[%*%-_][%*%-_][%*%-_]+$") then
      lines[l] = ("─"):rep(width)
    end
  end

  text = table.concat(lines, "\n")

  local open = true

  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      open = false
    end,
    once = true,
  })

  notify(text, vim.log.levels.INFO, {
    title = "Hover",
    keep = function()
      return open
    end,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_win_set_option(win, "spell", false)
    end,
  })
end

return M
