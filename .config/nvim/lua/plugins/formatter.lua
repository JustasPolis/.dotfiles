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
			nix = { "alejandra" },
			scss = { "prettier" },
			css = { "prettier" },
			ts = { "prettier" },
			js = { "prettier" },
			dart = { "dart_format" },
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
