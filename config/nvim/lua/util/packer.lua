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

  local group = vim.api.nvim_create_augroup("PackerUserConfig", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua", "*/plugins/*.lua" },
    group = group,
    callback = function()
      for p, _ in pairs(package.loaded) do
        if p:find("^plugins") == 1 then
          package.loaded[p] = nil
        end
      end
      require("plugins")
      vim.cmd([[PackerCompile]])
      util.info("Packer compiled...")
    end,
  })
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

function M.process_plugins(spec)
  if type(spec) == "table" then
    for _, v in pairs(spec) do
      M.process_plugins(v)
    end
    if spec.plugin then
      local ok, plugin = pcall(require, "plugins." .. spec.plugin)
      if not ok then
        util.error("Failed to load plugins." .. spec.plugin .. "\n\n" .. plugin)
      else
        for k, v in pairs(plugin) do
          spec[k] = type(v) == "function" and ([[require("plugins.%s").%s()]]):format(spec.plugin, k) or v
        end
      end
      spec.plugin = nil
    end
  end
end

function M.wrap(use)
  return function(spec)
    spec = M.process_local_plugins(spec)
    M.process_plugins(spec)
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
      fn(use, function(pkg)
        local name = M.get_name(pkg)
        name = name:gsub("%.nvim$", "")
        name = name:gsub("%.lua$", "")
        name = name:gsub("%.", "_")
        use({ pkg, plugin = name })
      end)
    end,
  })
end

return M
