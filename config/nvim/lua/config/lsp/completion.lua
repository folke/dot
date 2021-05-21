local M = {}

function M.setup(client, buffer)
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- fix function completion on all lsp servers
  if not client.request_orig then
    client.request_orig = client.request
    client.request = function(method, params, handler, bufnr)
      if method == "textDocument/completion" then
        local intercept = function(err, _method, result, client_id, _bufnr)
          local response = result or {}
          local items = response.items or response
          for _, item in ipairs(items) do
            -- 2: method
            -- 3: function
            -- 4: constructor
            if item.insertText == nil and (item.kind == 2 or item.kind == 3 or item.kind == 4) then
              item.insertText = item.label .. "(${1})"
              item.insertTextFormat = 2
            end
          end
          return handler(err, method, result, client_id, bufnr)
        end
        return client.request_orig(method, params, intercept, bufnr)
      end
      return client.request_orig(method, params, handler, bufnr)
    end
  end
end

return M
