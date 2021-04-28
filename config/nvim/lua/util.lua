_G.dump = function(...) print(vim.inspect(...)) end

local M = {}

local map = function(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})
  if opts.buffer ~= nil then
    local buffer = opts.buffer
    opts.buffer = nil
    return vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
  else
    return vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

M.map = function(mode, key, cmd, opt, defaults) return map(mode, key, cmd, opt, defaults) end

M.nmap = function(key, cmd, opts) return map("n", key, cmd, opts) end
M.vmap = function(key, cmd, opts) return map("v", key, cmd, opts) end
M.xmap = function(key, cmd, opts) return map("x", key, cmd, opts) end
M.imap = function(key, cmd, opts) return map("i", key, cmd, opts) end

M.nnoremap = function(key, cmd, opts) return map("n", key, cmd, opts, { noremap = true }) end
M.vnoremap = function(key, cmd, opts) return map("v", key, cmd, opts, { noremap = true }) end
M.xnoremap = function(key, cmd, opts) return map("x", key, cmd, opts, { noremap = true }) end
M.inoremap = function(key, cmd, opts) return map("i", key, cmd, opts, { noremap = true }) end

function M.float_terminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local vpad = 4
  local hpad = 10
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns - hpad * 2,
    height = vim.o.lines - vpad * 2,
    row = vpad,
    col = hpad,
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
  })
  vim.fn.termopen(cmd)
  local autocmd = {
    "autocmd! TermClose <buffer> lua",
    string.format("vim.api.nvim_win_close(%d, {force = true});", win),
    string.format("vim.api.nvim_buf_delete(%d, {force = true});", buf)
  }
  vim.cmd(table.concat(autocmd, " "))
  vim.cmd [[startinsert]]
end

M.zen_win = nil

function M.zen_mode()
  if M.zen_win and vim.api.nvim_win_is_valid(M.zen_win) then
    vim.api.nvim_win_close(M.zen_win, { force = true })
    return
  end
  local vpad = 0
  local hpad = math.floor(vim.o.columns * .2)

  local bg_buf = vim.api.nvim_create_buf(false, true)
  local bg_win = vim.api.nvim_open_win(bg_buf, false, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    row = 1,
    col = 1,
    style = "minimal"
  })
  vim.api.nvim_win_set_option(bg_win, "winhighlight", "NormalFloat:Normal")

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns - hpad * 2,
    height = vim.o.lines - vpad * 2,
    row = vpad,
    col = hpad
    -- style = "minimal"
  })
  vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")

  local autocmd = {
    "autocmd! WinClosed " .. win .. " ++once lua",
    string.format("vim.api.nvim_win_close(%d, {force = true});", bg_win),
    string.format("vim.api.nvim_buf_delete(%d, {force = true});", bg_buf)
  }
  vim.cmd(table.concat(autocmd, " "))
  M.zen_win = win
end

return M
