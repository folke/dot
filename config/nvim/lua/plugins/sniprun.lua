local M = {
  run = "bash ./install.sh",
  cmd = "SnipRun",
  keys = { "<leader>r" },
  module = "sniprun",
}

function M.config()
  require("sniprun").setup({
    selected_interpreters = { "Lua_nvim" },
    display = { "NvimNotify" },
    show_no_output = { "NvimNotify" },
  })
  vim.keymap.set("n", "<leader>r", function()
    require("sniprun").run()
  end, { silent = true, remap = true })
  vim.keymap.set("v", "<leader>r", function()
    require("sniprun").run("v")
  end, { silent = true })
end

return M
