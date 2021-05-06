local library = {}

local path = vim.split(package.path, ";")

local function add(package)
  package = type(package) == "string" and { package } or package
  for _, p in pairs(package) do
    library[p] = true
    table.insert(path, p .. "/?.lua")
    table.insert(path, p .. "/?/init.lua")
  end
end

add(vim.fn.expand("$VIMRUNTIME/lua"))
add(vim.fn.expand("~/.config/nvim/lua", false, true))
add(vim.fn.expand("~/.local/share/nvim/site/pack/packer/opt/*/lua", false, true))
add(vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/*/lua", false, true))

-- dump(library)
-- dump(path)
return {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = path
      },
      completion = { callSnippet = "Both" },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = library,
        maxPreload = 2000,
        preloadFileSize = 50000
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false }
    }
  }
}
