_G.dump = function(...) print(vim.inspect(...)) end

local M = {}

M.map = function(mode, key, cmd, opts)
  -- dump({ mode = mode, key = key, cmd = cmd, opts = opts })
  opts = vim.tbl_deep_extend("force", { noremap = true, silent = true }, opts or {})
  if opts.bufnr ~= nil then
    local bufnr = opts.bufnr
    opts.bufnr = nil
    return vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, opts)
  else
    return vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

M.nmap = function(key, cmd, opts) return M.map("n", key, cmd, opts) end

M.vmap = function(key, cmd, opts) return M.map("v", key, cmd, opts) end

M.imap = function(key, cmd, opts) return M.map("i", key, cmd, opts) end

return M
