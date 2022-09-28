local M = {}

M.event = "BufReadPre"

function M.config()
  local indent = require("indent_blankline")

  --- PERF: debounce indent-blankline refresh
  local refresh = indent.refresh
  indent.refresh = require("util").debounce(100, refresh)

  indent.setup({
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "neo-tree",
      "Trouble",
    },
    char = "│",
    use_treesitter_scope = false,
    show_trailing_blankline_indent = false,
    show_current_context = true,
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  })
end

return M
