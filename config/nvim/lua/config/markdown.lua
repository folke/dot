-- Use proper syntax highlighting in code blocks
local fences = {
  "lua",
  "vim",
  "json",
  "typescript",
  "javascript",
  "js=javascript",
  "ts=typescript",
  "shell=sh",
  "python",
  "sh",
  "console=sh",
}
vim.g.markdown_fenced_languages = fences

-- vim-pandoc/vim-pandoc
vim.g["pandoc#syntax#codeblocks#embeds#langs"] = fences
vim.g["pandoc#syntax#conceal#urls"] = 1

-- sidofc/mkdx
vim.g["mkdx#settings"] = {
  highlight = { enable = 1 },
  enter = { shift = 1 },
  links = { external = { enable = 1 } },
  toc = { text = "Table of Contents", update_on_write = 1 },
  fold = { enable = 0 },
}

-- plasticboy/vim-markdown
vim.g.vim_markdown_folding_level = 10
vim.g.vim_markdown_fenced_languages = fences
vim.g.vim_markdown_folding_style_pythonic = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1

-- gabrielelana/vim-markdown
vim.g.markdown_enable_conceal = 1
vim.g.markdown_enable_mappings = 1
vim.g.markdown_enable_insert_mode_mappings = 1
vim.g.markdown_enable_insert_mode_leader_mappings = 1
