require("gitsigns").setup({
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
    ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },

    ["n <leader>ghs"] = "<cmd>lua require\"gitsigns\".stage_hunk()<CR>",
    ["n <leader>ghu"] = "<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>",
    ["n <leader>ghr"] = "<cmd>lua require\"gitsigns\".reset_hunk()<CR>",
    ["n <leader>ghR"] = "<cmd>lua require\"gitsigns\".reset_buffer()<CR>",
    ["n <leader>ghp"] = "<cmd>lua require\"gitsigns\".preview_hunk()<CR>",
    ["n <leader>ghb"] = "<cmd>lua require\"gitsigns\".blame_line()<CR>",

    -- Text objects
    ["o ih"] = ":<C-U>lua require\"gitsigns\".select_hunk()<CR>",
    ["x ih"] = ":<C-U>lua require\"gitsigns\".select_hunk()<CR>"
  }
})
