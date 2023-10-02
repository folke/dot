-- vim.keymap.set("n", "<leader>w", "<cmd>lua vim.notify('hi')<cr>", { desc = "foooo" })
-- vim.keymap.set("n", ";", ":")
return {
  {
    "echasnovski/nvim",
    name = "mini.dev",
    submodules = false,
    config = function()
      require("mini-dev.pick").setup()
    end,
    init = function()
      vim.api.nvim_create_user_command("Pick", function(cmd)
        require("mini-dev.pick").builtin[cmd.args]()
      end, {
        nargs = "?",
        complete = function(_, line)
          local prefix = vim.split(vim.trim(line), "%s+")[2] or ""
          ---@param key string
          return vim.tbl_filter(function(key)
            return key:find(prefix, 1, true) == 1
          end, vim.tbl_keys(require("mini-dev.pick").builtin))
        end,
      })
    end,
  },
  {
    "AckslD/muren.nvim",
    opts = {
      patterns_width = 60,
      patterns_height = 20,
      options_width = 40,
      preview_height = 24,
    },
    cmd = "MurenToggle",
  },
  -- { "ggandor/leap.nvim" },
  -- { "3rd/image.nvim", opts = {}, ft = "markdown", lazy = false, enabled = true },
  {
    "folke/flash.nvim",
    enabled = true,
    init = function()
      -- vim.keymap.set("n", "x", "<cmd>lua require('flash').jump()<cr>")
      -- vim.opt.keymap = "emoji"
    end,
    ---@type Flash.Config
    opts = {
      -- labels = "#abcdef",
      modes = {
        -- char = { jump_labels = false },
        -- treesitter = {
        --   label = {
        --     rainbow = { enabled = true },
        --   },
        -- },
        treesitter_search = {
          label = {
            rainbow = { enabled = true },
            -- format = function(opts)
            --   local label = opts.match.label
            --   if opts.after then
            --     label = label .. ">"
            --   else
            --     label = "<" .. label
            --   end
            --   return { { label, opts.hl_group } }
            -- end,
          },
        },
      },
      -- search = { mode = "fuzzy" },
      -- labels = "😅😀🏇🐎🐴🐵🐒",
    },
  },
}
