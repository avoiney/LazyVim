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
  name = "Run doctests in file",
  module = "doctest",
  args = { "${file}" },
  noDebug = true,
  pythonPath = "/home/avoiney/.asdf/shims/python",
})
