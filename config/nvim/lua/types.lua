vim = require("vim.shared")

local uri = require("vim.uri")
vim.uri_from_bufnr = uri.uri_from_bufnr
vim.uri_from_bufname = uri.uri_from_bufname
vim.uri_from_fname = uri.uri_from_fname
vim.uri_to_bufnr = uri.uri_to_bufnr
vim.uri_to_fname = uri.uri_to_fname

vim.lsp = require("vim.lsp")
vim.inspect = require("vim.inspect").inspect
vim.treesitter = require("vim.treesitter")
