-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.filetype.add({
  extension = {
    overlay = "dts",
    keymap = "dts",
    conf = "dosini",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local commentstrings = {
      dts = "// %s",
    }
    local ft = vim.bo.filetype
    if commentstrings[ft] then
      vim.bo.commentstring = commentstrings[ft]
    end
  end,
})

-- Work-around for https://github.com/mutagen-io/mutagen/issues/163
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file:find("pyscript") then
      file = file:gsub(".*nodes/ha/", "")
      vim.defer_fn(function()
        vim.fn.system(("ssh root@10.0.0.4 touch /config/%s"):format(file))
      end, 2000)
    end
  end,
})
