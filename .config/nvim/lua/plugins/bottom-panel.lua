return {
  "JustasPolis/bottom-panel.nvim",
  dev = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "VimEnter",
  keys = {
    {
      "<leader>pm",
      mode = { "n" },
      function()
        require("bottom-panel").navigate("Messages")
      end,
      desc = "PanelMessages",
    },
  },
  config = function()
    require("bottom-panel").setup({
      open_on_launch = true,
      tabs = {
        { name = "Diagnostics", module = "diagnostics" },
        { name = "Messages", module = "messages" },
      },
    })
  end,
  lazy = false,
}
