return {
  "crusj/bookmarks.nvim",
  keys = {
    { "<tab><tab>", mode = { "n" } },
  },
  branch = "main",
  dependencies = { "nvim-web-devicons" },
  config = function()
    require("bookmarks").setup({
      virt_pattern = { "*.go", "*.lua", "*.sh", "*.php", "*.rs", "*.py" },
      virt_text = "", -- Show virt text at the end of bookmarked lines, if it is empty, use the description of bookmarks instead.
      sign_icon = "󰃃", -- if it is not empty, show icon in signColumn.
    })
    require("telescope").load_extension("bookmarks")
  end,
}
