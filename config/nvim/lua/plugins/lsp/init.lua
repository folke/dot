local M = {
  event = "BufReadPre",
}

function M.config()
  require("lua-dev").setup({
    library = {
      runtime = "~/projects/neovim/runtime/",
    },
  })
  require("mason")
  require("plugins.lsp.diagnostics").setup()
  require("fidget").setup({ text = { spinner = "dots" } })
  require("neoconf").setup()
  local function on_attach(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
    require("plugins.lsp.formatting").setup(client, bufnr)
    require("plugins.lsp.keys").setup(client, bufnr)
  end

  ---@type lspconfig.options
  local servers = {
    ansiblels = {},
    bashls = {},
    clangd = {},
    cssls = {},
    dockerls = {},
    tsserver = {},
    eslint = {},
    html = {},
    jsonls = {
      settings = {
        json = {
          format = {
            enable = true,
          },
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    pyright = {},
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
        },
      },
    },
    sumneko_lua = {
      -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
      single_file_support = true,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          completion = {
            workspaceWord = false,
          },
          misc = {
            parameters = {
              "--log-level=trace",
            },
          },
          diagnostics = {
            groupFileStatus = {
              ["ambiguity"] = "Opened",
              ["await"] = "Opened",
              ["codestyle"] = "None",
              ["duplicate"] = "Opened",
              ["global"] = "Opened",
              ["luadoc"] = "Opened",
              ["redefined"] = "Opened",
              ["strict"] = "Opened",
              ["strong"] = "Opened",
              ["type-check"] = "Opened",
              ["unbalanced"] = "Opened",
              ["unused"] = "Opened",
            },
            unusedLocalExclude = { "_*" },
          },
          format = {
            enable = false,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
              continuation_indent_size = "2",
            },
          },
        },
      },
    },
    vimls = {},
    -- tailwindcss = {},
  }
  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  ---@type _.lspconfig.options
  local options = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }

  for server, opts in pairs(servers) do
    opts = vim.tbl_deep_extend("force", {}, options, opts or {})
    if server == "tsserver" then
      require("typescript").setup({ server = opts })
    else
      require("lspconfig")[server].setup(opts)
    end
  end

  require("plugins.null-ls").setup(options)
end

return M
