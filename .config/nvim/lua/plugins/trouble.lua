return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = true,
  opts = {
    position = 'bottom',
    height = 5,
    padding = false,
    fold_open = "", -- icon used for open folds
    fold_closed = "",
    auto_preview = false,
    indent_lines = false,
    include_declaration = {}
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>t",
      function()
        local trouble = require('trouble')
        if not trouble.is_open() then
          trouble.open()
          trouble.action("cancel")
        else
          trouble.close()
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
  },
}
