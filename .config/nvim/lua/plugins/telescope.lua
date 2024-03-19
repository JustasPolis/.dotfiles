return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = {
			{
				"isak102/telescope-git-file-history.nvim",
				dependencies = { "tpope/vim-fugitive" },
			},
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-file-browser.nvim" },
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
				"<leader>fb",
				function()
					require("telescope").extensions.file_browser.file_browser()
				end,
				desc = "file browser telescope",
			},
		},
		config = function()
			require("telescope").setup({
				extensions = {
					file_browser = {
						hijack_netrw = true,
						grouped = true,
						files = true,
						depth = "false",
						display_stat = false,
						git_status = false,
					},
				},
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
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("git_file_history")
		end,
	},
}
