vim.api.nvim_exec(
  [[
  augroup ScrollbarInit
    autocmd!
    autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
    autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
    autocmd WinLeave,FocusLost             * silent! lua require('scrollbar').clear()
  augroup end
]],
  false
)

vim.g.scrollbar_shape = { head = "▲", body = "█", tail = "▼" }

local hi = "LineNr"
vim.g.scrollbar_highlight = { head = hi, body = hi, tail = hi }

vim.g.scrollbar_excluded_filetypes = { "nerdtree", "tagbar", "dashboard", "NvimTree" }

vim.g.scrollbar_max_size = 6
vim.g.scrollbar_right_offset = 1
