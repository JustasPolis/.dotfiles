return {
  "echasnovski/mini.pairs",
  version = '*',
  lazy = true,
  event = { "InsertEnter" },
  opts = {},
  config = function()
    require('mini.pairs').setup()
  end
}
