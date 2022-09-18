local M = {
  cmd = { "TodoTrouble", "TodoTelescope" },
  module = "todo-comments",
  event = "BufReadPost",
}

function M.config()
  require("todo-comments").setup({ keywords = { TODO = { alt = { "WIP" } } } })
end

function M.init()
  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" })

  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" })
end

return M
