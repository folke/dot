local M = {
  event = "User PackerDefered",
}

function M.config()
  require("mini.jump").setup({})
end

function M.init()
  vim.keymap.set("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
  end)
end

return M
