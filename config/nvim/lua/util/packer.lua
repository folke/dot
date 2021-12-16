local util = require("util")

local M = {}

M.local_plugins = {}

function M.bootstrap()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd("packadd packer.nvim")
  end
  vim.cmd([[packadd packer.nvim]])
  -- vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- Auto compile when there are changes in plugins.lua
  vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
  ]])
end

function M.get_name(pkg)
  local parts = vim.split(pkg, "/")
  return parts[#parts], parts[1]
end

function M.has_local(name)
  return vim.loop.fs_stat(vim.fn.expand("~/projects/" .. name)) ~= nil
end

-- This method replaces any plugins with the local clone under ~/projects
function M.process_local_plugins(spec)
  if type(spec) == "string" then
    local name, owner = M.get_name(spec)
    local local_pkg = "~/projects/" .. name

    if M.local_plugins[name] or M.local_plugins[owner] or M.local_plugins[owner .. "/" .. name] then
      if M.has_local(name) then
        return local_pkg
      else
        util.error("Local package " .. name .. " not found")
      end
    end
    return spec
  else
    for i, s in ipairs(spec) do
      spec[i] = M.process_local_plugins(s)
    end
  end
  if spec.requires then
    spec.requires = M.process_local_plugins(spec.requires)
  end
  return spec
end

function M.wrap(use)
  return function(spec)
    spec = M.process_local_plugins(spec)
    use(spec)
  end
end

function M.setup(config, fn)
  -- HACK: see https://github.com/wbthomason/packer.nvim/issues/180
  vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

  M.bootstrap()
  local packer = require("packer")
  packer.init(config)
  M.local_plugins = config.local_plugins or {}
  return packer.startup({
    function(use)
      use = M.wrap(use)
      fn(use)
    end,
  })
end

return M
