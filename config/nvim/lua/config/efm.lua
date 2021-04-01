-- local luafmt = require "lt.lsp.servers.efm.formatters.luafmt"
local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}
local eslint_d = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" }
}

local languages = {
  -- lua = {luafmt},
  typescript = { prettier, eslint_d },
  javascript = { prettier, eslint_d },
  typescriptreact = { prettier, eslint_d },
  ["typescript.tsx"] = { prettier, eslint_d },
  javascriptreact = { prettier, eslint_d },
  ["javascript.jsx"] = { prettier, eslint_d },
  yaml = { prettier },
  json = { prettier },
  html = { prettier },
  scss = { prettier },
  css = { prettier },
  markdown = { prettier }
}

local bin_path = "efm-langserver"
return {
  cmd = {
    bin_path
    --[[ "-loglevel",
          "10",
          "-logfile",
          "/home/lucatrazzi/efm.log" ]]
  },
  root_dir = function()
    --[[ if not eslint_config_exists() then
            print 'eslint configuration not found'
            return nil
          end]]
    -- check if eslint_d installed globally!
    -- return lsp.util.root_pattern("package.json", ".git", vim.fn.getcwd())
    return vim.fn.getcwd()
  end,
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = true },
  settings = { rootMarkers = { "package.json", ".git" }, lintDebounce = 500, languages = languages }
}
