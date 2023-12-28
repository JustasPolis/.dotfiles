return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = {
      enabled = true,         -- enables the Noice cmdline UI
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      format = {
        cmdline = { pattern = "^:", icon = "󱦰", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
        input = {}, -- Used by input()
        -- lua = false, -- to disable a format, set to `false`
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,            -- enables the Noice messages UI
      view = "notify",           -- default view for messages
      view_error = "notify",     -- view for errors
      view_warn = "notify",      -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    lsp = {
      progress = {
        enabled = false,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = "mini",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = false,
        silent = false, -- set to true to not show a message if hover is not available
        view = nil,     -- when nil, use defaults from documentation
        opts = {},      -- merged with defaults from documentation
      },
      signature = {
        enabled = false,
        auto_open = {
          enabled = false,
          trigger = false, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = false, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50,   -- Debounce lsp signature help request by 50ms
        },
        view = nil,        -- when nil, use defaults from documentation
        opts = {},         -- merged with defaults from documentation
      },
      message = {
        enabled = false,
        view = "notify",
        opts = {},
      },
      -- defaults for hover and signature help
      documentation = {
        view = "hover",
        ---@type NoiceViewOptions
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },
    presets = {
      bottom_search = false,        -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
    views = {
      cmdline_popup = {
        backend = "popup",
        relative = "editor",
        focusable = false,
        enter = false,
        zindex = 200,
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          min_width = 60,
          width = "auto",
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NoiceCmdlinePopup",
            FloatTitle = "NoiceCmdlinePopupTitle",
            FloatBorder = "NoiceCmdlinePopupBorder",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
          winbar = "",
          foldenable = false,
          cursorline = false,
        },
      },
      mini = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 2000,
        reverse = true,
        focusable = false,
        position = {
          row = 0,
          col = "100%",
        },
        size = {
          width = "auto",
          height = 'auto'
        },
        border = {
          style = "none",
        },
        zindex = 250,
        win_options = {
          winbar = "",
          foldenable = false,
          winblend = 0,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
        },
      },
    },

  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  }
}
