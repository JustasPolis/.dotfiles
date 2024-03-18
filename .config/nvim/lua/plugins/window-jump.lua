return {
	"yorickpeterse/nvim-window",
	lazy = true,
	keys = {
		{ "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
	},
	config = true,
}
