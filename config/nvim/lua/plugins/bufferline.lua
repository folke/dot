local M = {
  event = "BufReadPre",
}

function M.config()
  local signs = require("plugins.lsp.diagnostics").signs

  signs = {
    error = signs.Error,
    warning = signs.Warn,
    info = signs.Info,
    hint = signs.Hint,
  }

  local severities = {
    "error",
    "warning",
    -- "info",
    -- "hint",
  }

  require("bufferline").setup({
    options = {
      show_close_icon = true,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      separator_style = "thick",
      diagnostics_indicator = function(_, _, diag)
        local s = {}
        for _, severity in ipairs(severities) do
          if diag[severity] then
            table.insert(s, signs[severity] .. diag[severity])
          end
        end
        return table.concat(s, " ")
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo Tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  })
end

-- function M.init()
--   vim.keymap.set("n", "<leader>bp", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
--   vim.keymap.set("n", "<leader>bn", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
--   vim.keymap.set("n", "[b", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
--   vim.keymap.set("n", "]b", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
-- end

return M
