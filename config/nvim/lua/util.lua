_G.dump = function(...) print(vim.inspect(...)) end

local M = {}

local map = function(mode, key, cmd, opts, defaults)
  -- dump({ mode = mode, key = key, cmd = cmd, opts = opts })
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})
  if opts.bufnr ~= nil then
    local bufnr = opts.bufnr
    opts.bufnr = nil
    return vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, opts)
  else
    return vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

M.map = function(mode, key, cmd, opt) return map(mode, key, cmd, opt) end

M.nmap = function(key, cmd, opts) return map("n", key, cmd, opts) end

M.vmap = function(key, cmd, opts) return map("v", key, cmd, opts) end

M.imap = function(key, cmd, opts) return map("i", key, cmd, opts) end

M.nnoremap = function(key, cmd, opts) return map("n", key, cmd, opts, { noremap = true }) end

M.vnoremap = function(key, cmd, opts) return map("v", key, cmd, opts, { noremap = true }) end

M.inoremap = function(key, cmd, opts) return map("i", key, cmd, opts, { noremap = true }) end

return M
