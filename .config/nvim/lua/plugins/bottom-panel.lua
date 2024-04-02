return {
  "JustasPolis/bottom-panel.nvim",
  dev = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "VimEnter",
  keys = {
    {
      "<leader>pd",
      mode = { "n" },
      function()
        require("bottom-panel").navigate("Diagnostics")
      end,
      desc = "PanelDiagnostics",
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
