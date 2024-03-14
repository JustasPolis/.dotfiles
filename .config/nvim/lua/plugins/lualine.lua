return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"folke/noice.nvim",
	},
	lazy = false,
	config = function()
		local theme = require("lualine.themes.auto")
		theme.normal.c.bg = "None"
		theme.inactive.c.bg = "None"
		theme.visual.c.bg = "None"
		theme.insert.c.bg = "None"
		theme.replace.c.bg = "None"
		theme.command.c.bg = "None"

		local lualine = require("lualine")
		lualine.setup({
			options = {
				icons_enabled = true,
				theme = theme,
				ignore_focus = { "Telescope", "Navigator", "help" },
				always_divide_middle = false,
				globalstatus = true,
				refresh = {
					statusline = 100,
				},
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						require("noice").api.status.lsp_progress.get,
						cond = require("noice").api.status.lsp_progress.has,
					},
					{
						require("noice").api.status.lsp_progress_done.get,
						cond = require("noice").api.status.lsp_progress_done.has,
					},
				},
				lualine_z = {
					{
						"branch",
						always_visible = true,
						icon = { "", padding = { left = 0, right = 0 }, color = { fg = "#e17792" } },
						color = { fg = "white", bg = "None" },
					},
				},
			},
		})
	end,
}
