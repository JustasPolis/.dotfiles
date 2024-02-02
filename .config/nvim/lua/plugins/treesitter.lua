return {
	"nvim-treesitter/nvim-treesitter",
	lazy = true,
	version = false,
	event = { "BufReadPost", "BufNewFile" },
  enabled = false,
	build = ":TSUpdate",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"cpp",
				"go",
				"lua",
				"python",
				"rust",
				"tsx",
        "nix",
				"typescript",
				"vimdoc",
				"vim",
				"javascript",
				"json",
				"regex",
				"bash",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = false },
		})
		---@diagnostic disable-next-line: deprecated
		vim.treesitter.language.register("bash", "zsh")
	end,
}
