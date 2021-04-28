return {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path

        path = {
          vim.split(package.path, ";"),
          "?.lua",
          "?/init.lua",
          vim.fn.expand "~/.luarocks/share/lua/5.3/?.lua",
          vim.fn.expand "~/.luarocks/share/lua/5.3/?/init.lua",
          "/usr/share/5.3/?.lua",
          "/usr/share/lua/5.3/?/init.lua"
        }

      },
      completion = { callSnippet = "Both" },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        },
        maxPreload = 2000,
        preloadFileSize = 50000
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false }
    }
  }
}
