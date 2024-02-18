return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				lazy = true,
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		cmd = "Telescope",
		keys = {
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Telescope find files",
			},
			{
				"<leader>lg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Telescope live grep",
			},
			{
				"<leader>gf",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "Telescope git files",
			},
			{
				"<leader>so",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Telescope grep string",
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = true,
							["<C-d>"] = true,
						},
					},
					preview = {
						hide_on_startup = false,
					},
					layout_strategy = "vertical",
					layout_config = {
						height = 0.999,
						width = 0.999,
						vertical = {
							preview_cutoff = 0,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
	},
}
