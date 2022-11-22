return {
  cmd = "Neogit",
  config = function()
    require("neogit").setup({
      kind = "split",
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = { diffview = true },
    })
  end,
  init = function()
    vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=floating<cr>", { desc = "Neogit" })
  end,
}
