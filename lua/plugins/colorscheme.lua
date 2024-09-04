return {
  -- { "ellisonleao/gruvbox.nvim" },
  { "rakr/vim-two-firewatch" },
  { "Yazeed1s/oh-lucy.nvim" },
  { "EdenEast/nightfox.nvim" },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      -- your optional config goes here, see below.
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "bluloco-light",
    },
  },
}
