return {
  "JustasPolis/bottom-panel.nvim",
  dev = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    require("bottom-panel").setup("hello world")
  end,
}
