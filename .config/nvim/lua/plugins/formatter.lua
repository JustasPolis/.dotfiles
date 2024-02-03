return {
	"stevearc/conform.nvim",
	lazy = true,
	opts = {
		formatters_by_ft = {
			swift = { "swiftformat" },
			lua = { "stylua" },
			rust = { "rustfmt" },
			go = { "gofmt" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			nix = { "nixfmt" },
			fish = { "fish_indent" },
		},
	},
	keys = {
		{
			"<C-f>",
			mode = { "n", "x", "o" },
			function()
				require("conform").format({ timeout_ms = 500, lsp_fallback = false })
			end,
			desc = "Format File",
		},
	},
}
