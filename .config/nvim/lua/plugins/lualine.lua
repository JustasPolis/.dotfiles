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

		local lsp_progress
		local client

		vim.api.nvim_create_autocmd("LspProgress", {
			group = vim.api.nvim_create_augroup("lsp_progress", { clear = true }),
			callback = function(event)
				local percentage = event.data.result.value.percentage
				client = vim.lsp.get_client_by_id(event.data.client_id).name
				if percentage == nil then
					lsp_progress = "100"
				else
					if event.data.result.value.kind == "end" then
						lsp_progress = "100"
					else
						lsp_progress = tostring(event.data.result.value.percentage)
					end
				end
				lualine.refresh()
			end,
		})

		local function lsp()
			if lsp_progress == nil then
				return ""
			else
				return lsp_progress
			end
		end
		local function client_fn()
			if client == nil then
				return ""
			else
				return client
			end
		end

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = theme,
				ignore_focus = { "Telescope", "Navigator", "help" },
				always_divide_middle = false,
				globalstatus = true,
				refresh = {
					statusline = 50000,
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
						lsp,
					},
					{
						client_fn,
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
