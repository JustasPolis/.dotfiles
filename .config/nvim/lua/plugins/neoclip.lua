return {
	"AckslD/nvim-neoclip.lua",
	lazy = true,
	dependencies = {
		"kkharji/sqlite.lua",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>sc",
			function()
				vim.cmd([[Telescope neoclip]])
			end,
			desc = "show neoclip",
		},
	},
	config = function()
		require("neoclip").setup({
			enable_persistent_history = true,
		})
	end,
}
