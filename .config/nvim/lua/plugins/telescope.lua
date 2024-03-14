return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"smartpde/telescope-recent-files",
			"nvim-treesitter/nvim-treesitter",
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
			{
				"<leader>rf",
				function()
					require("telescope").extensions.recent_files.pick()
				end,
				desc = "Recent files telescope",
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--hidden",
						"--glob",
						"!.git/*",
						"--with-filename",
						"--column",
						"--no-ignore",
					},
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
			require("telescope").load_extension("recent_files")
		end,
	},
}
