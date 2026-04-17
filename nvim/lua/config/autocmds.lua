-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- backups
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.filetype.add({
  extension = {
    overlay = "dts",
    keymap = "dts",
  },
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("oxlint", { clear = true }),
  callback = function(ev)
    if vim.api.nvim_buf_get_name(ev.buf):find(".oxlintrc") and #vim.lsp.get_clients({ name = "oxlint" }) > 0 then
      Snacks.notify("Restarting oxlint...")
      vim.cmd("lsp restart oxlint")
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    local method = "textDocument/inlayHint"
    local INLAY_HINT_MAX_LEN = 30
    local INLAY_HINT_ELLIPSIS = "…"
    local orig = vim.lsp.handlers[method]
    ---@param result lsp.InlayHint[]
    vim.lsp.handlers[method] = function(err, result, ctx, config)
      if result then
        for _, hint in ipairs(result) do
          local label = hint.label
          if type(label) == "string" then
            hint.label = #label > INLAY_HINT_MAX_LEN and (label:sub(1, INLAY_HINT_MAX_LEN) .. INLAY_HINT_ELLIPSIS)
              or label
          else
            local len, prev_len, parts = 0, 0, #label
            label = vim.tbl_filter(function(part)
              prev_len, len = len, len + #part.value
              return prev_len < INLAY_HINT_MAX_LEN
            end, label)
            if #label < parts then
              table.insert(label, { value = INLAY_HINT_ELLIPSIS })
            end
            hint.label = label
          end
        end
      end
      return orig(err, result, ctx, config)
    end
  end,
})
