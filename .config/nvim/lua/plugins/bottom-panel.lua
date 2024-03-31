return {
  "JustasPolis/bottom-panel.nvim",
  dev = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("bottom-panel").setup()
  end,
  lazy = false,
}
