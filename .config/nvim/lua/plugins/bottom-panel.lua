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
      initial_tab = "Messages",
      tabs = {
        { name = "Messages", module = "messages" },
        { name = "Diagnostics", module = "diagnostics" },
      },
    })
  end,
  lazy = false,
  priority = 999,
}
