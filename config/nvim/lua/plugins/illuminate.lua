return {
  event = "User PackerDefered",
  module = "illuminate",
  config = function()
    require("illuminate").configure({ delay = 200 })
  end,
  init = function()
    vim.keymap.set("n", "]]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "Next Reference" })
    vim.keymap.set("n", "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "Prev Reference" })
  end,
}
