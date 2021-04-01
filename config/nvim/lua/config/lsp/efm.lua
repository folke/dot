local luafmt = { formatCommand = "lua-format", formatStdin = true }

local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" }
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x -",
  lintStdin = true,
  lintFormats = { "%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m" }
}

return {
  init_options = { documentFormatting = true },
  settings = {
    rootMarkers = { "package.json", ".git" },
    languages = {
      lua = { luafmt },
      typescript = { prettier, eslint },
      javascript = { prettier, eslint },
      typescriptreact = { prettier, eslint },
      javascriptreact = { prettier, eslint },
      ["typescript.tsx"] = { prettier, eslint },
      ["javascript.tsx"] = { prettier, eslint },
      yaml = { prettier },
      json = { prettier },
      html = { prettier },
      scss = { prettier },
      css = { prettier },
      markdown = { prettier },
      sh = { shellcheck }
    }
  }
}
