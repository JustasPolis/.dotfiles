return {
	"JustasPolis/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = true,
	opts = {
		position = "bottom",
		height = 3,
		padding = false,
		fold_open = "", -- icon used for open folds
		fold_closed = "",
		auto_preview = false,
		indent_lines = false,
		use_diagnostic_signs = true,
		auto_open = true,
		auto_close = false,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>t",
			function()
				local trouble = require("trouble")
				trouble.toggle(nil)
			end,
			desc = "Previous trouble/quickfix item",
		},
	},
}
