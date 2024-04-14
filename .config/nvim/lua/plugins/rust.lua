return {
  "JustasPolis/rust.nvim",
  dev = true,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  cmd = "Cargo",
  lazy = false,
  config = function()
    require("rust").setup()
  end,
}
