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
}
