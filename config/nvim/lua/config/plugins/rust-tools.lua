local M = {
  "simrat39/rust-tools.nvim",
}

function M.setup(options)
  local opts = {
    tools = { -- rust-tools options
      --   -- Automatically set inlay hints (type hints)
      --   autoSetHints = true,

      --   -- Whether to show hover actions inside the hover window
      --   -- This overrides the default hover handler
      --   hover_with_actions = true,

      --   -- how to execute terminal commands
      --   -- options right now: termopen / quickfix
      --   executor = require("rust-tools/executors").termopen,

      --   runnables = {
      --     -- whether to use telescope for selection menu or not
      --     use_telescope = true,

      --     -- rest of the opts are forwarded to telescope
      --   },

      --   debuggables = {
      --     -- whether to use telescope for selection menu or not
      --     use_telescope = true,

      --     -- rest of the opts are forwarded to telescope
      --   },

      --   -- These apply to the default RustSetInlayHints command
      inlay_hints = {

        --     -- Only show inlay hints for the current line
        --     only_current_line = false,

        --     -- Event which triggers a refersh of the inlay hints.
        --     -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
        --     -- not that this may cause  higher CPU usage.
        --     -- This option is only respected when only_current_line and
        --     -- autoSetHints both are true.
        --     only_current_line_autocmd = "CursorHold",

        --     -- whether to show parameter hints with the inlay hints or not
        --     show_parameter_hints = true,

        --     -- prefix for parameter hints
        parameter_hints_prefix = "  <-  ",

        --     -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "  =>  ",

        --     -- whether to align to the length of the longest line in the file
        -- max_len_align = true,

        --     -- padding from the left if max_len_align is true
        -- max_len_align_padding = 10,

        --     -- whether to align to the extreme right or not
        --     right_align = false,

        --     -- padding from the right if right_align is true
        --     right_align_padding = 7,

        --     -- The color of the hints
        highlight = "LspCodeLens",
      },

      --   hover_actions = {
      --     -- the border that is used for the hover window
      --     -- see vim.api.nvim_open_win()
      --     border = {
      --       { "╭", "FloatBorder" },
      --       { "─", "FloatBorder" },
      --       { "╮", "FloatBorder" },
      --       { "│", "FloatBorder" },
      --       { "╯", "FloatBorder" },
      --       { "─", "FloatBorder" },
      --       { "╰", "FloatBorder" },
      --       { "│", "FloatBorder" },
      --     },

      --     -- whether the hover action window gets automatically focused
      --     auto_focus = false,
      --   },

      --   -- settings for showing the crate graph based on graphviz and the dot
      --   -- command
      --   crate_graph = {
      --     -- Backend used for displaying the graph
      --     -- see: https://graphviz.org/docs/outputs/
      --     -- default: x11
      --     backend = "x11",
      --     -- where to store the output, nil for no output stored (relative
      --     -- path from pwd)
      --     -- default: nil
      --     output = nil,
      --     -- true for all crates.io and external crates, false only the local
      --     -- crates
      --     -- default: true
      --     full = true,
      --   },
    },

    -- -- all the opts to send to nvim-lspconfig
    -- -- these override the defaults set by rust-tools.nvim
    -- -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = options, -- rust-analyer options

    -- -- debugging stuff
    -- dap = {
    --   adapter = {
    --     type = "executable",
    --     command = "lldb-vscode",
    --     name = "rt_lldb",
    --   },
    -- },
  }

  require("rust-tools").setup(opts)
end

return M
