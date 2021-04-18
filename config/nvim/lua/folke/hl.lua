local highlighter = require("vim.treesitter.highlighter")
local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

function M.get_treesitter_hl()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local self = highlighter.active[buf]

  if not self then return {} end

  local matches = {}

  self.tree:for_each_tree(function(tstree, tree)
    if not tstree then return end

    local root = tstree:root()
    local root_start_row, _, root_end_row, _ = root:range()

    -- Only worry about trees within the line range
    if root_start_row > row or root_end_row < row then return end

    local query = self:get_query(tree:lang())

    -- Some injected languages may not have highlight queries.
    if not query:query() then return end

    local iter = query:query():iter_captures(root, self.bufnr, row, row + 1)

    while true do
      local capture, node = iter()
      if capture == nil then break end

      local hl = query.hl_cache[capture]

      if hl and ts_utils.is_in_node_range(node, row, col) then
        local c = query._query.captures[capture] -- name of the capture in the query
        if c ~= nil then
          table.insert(matches, "* **@" .. c .. "** -> " .. hl .. " -> **" ..
                         query:_get_hl_from_capture(capture) .. "**")
        end
      end
    end

  end, true)
  return matches
end

function M.get_syntax_hl()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local matches = {}
  for _, i1 in ipairs(vim.fn.synstack(line, col)) do
    local i2 = vim.fn.synIDtrans(i1)
    local n1 = vim.fn.synIDattr(i1, "name")
    local n2 = vim.fn.synIDattr(i2, "name")
    table.insert(matches, "* " .. n1 .. " -> **" .. n2 .. "**")
  end
  return matches
end

function M.show_hl_captures()
  local buf = vim.api.nvim_get_current_buf()
  local lines = {}
  local matches
  if highlighter.active[buf] then
    table.insert(lines, "# Treesitter")
    matches = M.get_treesitter_hl()
  else
    table.insert(lines, "# Syntax")
    matches = M.get_syntax_hl()
  end
  if #matches == 0 then table.insert(lines, "* No highlight groups found") end
  table.insert(lines, "")
  for _, line in ipairs(matches) do table.insert(lines, line) end
  vim.lsp.util.open_floating_preview(lines, "markdown",
                                     { border = "single", pad_left = 4, pad_right = 4 })
end

return M
