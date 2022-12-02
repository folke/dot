return {
  "karb94/neoscroll.nvim",
  keys = { "<C-u>", "<C-d>", "gg", "G" },
  config = function()
    require("neoscroll").setup({
      mappings = { "<C-u>", "<C-d>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      -- respect_scrolloff = true,
    })
    local map = {}

    map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
    map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
    -- map["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
    -- map["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }
    map["<C-y>"] = { "scroll", { "-0.10", "false", "80" } }
    map["<C-e>"] = { "scroll", { "0.10", "false", "80" } }
    map["zt"] = { "zt", { "150" } }
    map["zz"] = { "zz", { "150" } }
    map["zb"] = { "zb", { "150" } }

    require("neoscroll.config").set_mappings(map)
  end,
}
