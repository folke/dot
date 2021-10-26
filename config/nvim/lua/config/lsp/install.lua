local util = require("util")

local M = {}

function M.install_missing(servers)
  local lspi_servers = require("nvim-lsp-installer.servers")
  for server, _ in pairs(servers) do
    local ok, s = lspi_servers.get_server(server)
    if ok then
      if not s:is_installed() then
        s:install()
      end
    else
      util.error("Server " .. server .. " not found")
    end
  end
end

function M.setup(servers, options)
  local lspi = require("nvim-lsp-installer")
  lspi.on_server_ready(function(server)
    local opts = vim.tbl_deep_extend("force", options, servers[server.name] or {})
    server:setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end)

  M.install_missing(servers)
end

return M
