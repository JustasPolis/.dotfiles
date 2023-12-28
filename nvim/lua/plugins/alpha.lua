return {
  'goolord/alpha-nvim',
  lazy = true,
  event = "VimEnter",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require('alpha')
    alpha.setup(require 'alpha.themes.dashboard'.config)

  end
}
