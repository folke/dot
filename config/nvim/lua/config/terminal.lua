require"toggleterm".setup {
  size = 20,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal"
}

-- Hide number column for
vim.cmd [[au TermOpen * setlocal nonumber norelativenumber]]
