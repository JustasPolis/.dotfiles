return {
  "JustasPolis/statusline.nvim",
  dev = true,
  priority = 999,
  config = function()
    require("statusline").setup()
  end,
  lazy = false,

}
