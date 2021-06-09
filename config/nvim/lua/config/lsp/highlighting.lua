return {
  setup = function(client) -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      require("illuminate").on_attach(client)
      vim.api.nvim_exec(
        [[augroup lsp_document_highlight
            autocmd! * <buffer>
            " autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.signature_help()
            " autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END]],
        false
      )
    end
  end,
}
