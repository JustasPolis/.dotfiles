local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = false, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = true,
  event = "BufEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    {
      "<leader>e",
      mode = { "n", "x", "o" },
      function() require("nvim-tree.api").tree.toggle() end,
      desc = "Toggle NvimTree"
    },
  },
  config = function()
    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      respect_buf_cwd = true,
      hijack_cursor = true,
      on_attach = my_on_attach,
      sync_root_with_cwd = true,
      view = {
        cursorline = true,
        width = { min = 30, max = 30, padding = 4 },
        side = "left",
        signcolumn = "no",
        number = false,
        relativenumber = false
      },
      renderer = {
        root_folder_label = false,
        indent_width = 1,
        icons = {
          padding = " ",
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = false,
            modified = false
          }
        }
      }
    }
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup("config_nvim_tree_buf_enter", { clear = true }),
      pattern = 'NvimTree_1',
      command = 'set termguicolors | hi Cursor blend=100 | set guicursor+=a:Cursor/lCursor'
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      group = vim.api.nvim_create_augroup("config_nvim_tree_leave", { clear = true }),
      pattern = "NvimTree_1",
      command = 'set termguicolors | hi Cursor blend=0'
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup("config_nvim_tree_vim_enter", { clear = true }),
      pattern = 'NvimTree_1',
      desc = 'Hide Cursor',
      callback = function()
        local hl = vim.api.nvim_get_hl(0, { name = 'Cursor' })
        hl.blend = 100
        vim.api.nvim_set_hl(0, 'Cursor', hl)
        vim.opt.guicursor:append('a:Cursor/lCursor')
      end,
    })
  end
}
