return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			format = {
				cmdline = { pattern = "^:", icon = "󱦰", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
				input = {},
			},
		},
		messages = {
			enabled = true,
			view = "notify",
			view_error = "notify",
			view_warn = "notify",
			view_history = "messages",
			view_search = "virtualtext",
		},
		lsp = {
			progress = {
				enabled = false,
				format = "lsp_progress",
				format_done = "lsp_progress_done",
				throttle = 1000 / 30,
				view = "mini",
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = {
				enabled = false,
				silent = false,
				view = nil,
				opts = {},
			},
			signature = {
				enabled = false,
				auto_open = {
					enabled = false,
					trigger = false,
					luasnip = false,
					throttle = 50,
				},
				view = nil,
				opts = {},
			},
			message = {
				enabled = false,
				view = "notify",
				opts = {},
			},
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
			bottom_search = false,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = false,
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
					height = "auto",
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
	},
}
