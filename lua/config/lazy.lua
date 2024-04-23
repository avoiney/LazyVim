local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- first load extension
require("telescope").load_extension("rest")

local dap = require("dap")
dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      options = {
        source_filetype = "python",
      },
    })
  else
    cb({
      type = "executable",
      command = "/home/avoiney/.asdf/shims/python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    })
  end
end

local configs = dap.configurations.python or {}
dap.configurations.python = configs
table.insert(configs, {
  type = "python",
  request = "attach",
  name = "Attach remote",
  connect = function()
    local host = vim.fn.input("Host [127.0.0.1]: ")
    host = host ~= "" and host or "127.0.0.1"
    local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
    return { host = host, port = port }
  end,
})
table.insert(configs, {
  type = "python",
  request = "launch",
  name = "Launch file",
  program = "${file}",
  pythonPath = "/home/avoiney/.asdf/shims/python",
})
table.insert(configs, {
  type = "python",
  request = "launch",
  name = "Launch file with arguments",
  program = "${file}",
  args = function()
    local args_string = vim.fn.input("Arguments: ")
    return vim.split(args_string, " +")
  end,
  pythonPath = "/home/avoiney/.asdf/shims/python",
})
table.insert(configs, {
  type = "python",
  request = "launch",
  name = "Run doctests in file",
  module = "doctest",
  args = { "${file}" },
  noDebug = true,
  pythonPath = "/home/avoiney/.asdf/shims/python",
})
