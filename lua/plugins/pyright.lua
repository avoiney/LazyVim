return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOits
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {
          settings = {
            python = {
              analysis = {
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
    },
  },
}
