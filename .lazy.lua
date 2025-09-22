return {
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       ["kdl"] = { "kdlfmt" },
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "kdl",
        "hyprlang",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.kdl = { "niri" }
      require("lint").linters.niri = {
        name = "niri",
        cmd = "niri",
        stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
        append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
        args = { "validate", "-c" }, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
        stream = "stderr", -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
        ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
        env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.

        ---@type lint.parse
        parser = function(out, buf)
          local lines = vim.split(out, "\n")
          local ret = {} ---@type vim.Diagnostic[]
          local e = {} ---@type string[]
          local function add()
            if #e == 0 then
              return
            end
            local msg = table.concat(e, "\n")
            local lnum = msg:match("%[.-:(%d+):(%d+)%]")
            ret[#ret + 1] = {
              bufnr = buf,
              lnum = lnum and tonumber(lnum) or 0,
              source = "niri",
              message = msg,
              severity = vim.diagnostic.severity.ERROR,
            }
          end
          for _, line in ipairs(lines) do
            if line:match("^Error:") then
              add()
              e = { line }
            elseif #e > 0 then
              e[#e + 1] = line
            end
          end
          add()
          return ret
        end,
      }
    end,
  },
}
