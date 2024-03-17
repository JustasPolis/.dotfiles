return {
	"neovim/nvim-lspconfig",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neodev.nvim", opts = {} },
		"folke/trouble.nvim",
	},
	config = function()
		local on_attach = function(_, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			vim.lsp.inlay_hint.enable(bufnr, true)

			map("K", vim.lsp.buf.hover, "Hover Documentation")

			map("<leader>sd", function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = "always",
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end, "LSP diagnostic hover")

			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
			map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = false,
					virtual_text = false,
				})
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		require("lspconfig").rust_analyzer.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = { command = "clippy", extraArgs = { "--no-deps" } },
					diagnostics = { disabled = { "needless_return" }, experimental = { enable = true } },
				},
			},
		})

		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		require("lspconfig").nil_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		require("lspconfig").cssls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "css-languageserver", "--stdio" },
		})

		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					telemetry = {
						enable = false,
					},
					hint = {
						enable = true,
					},
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						maxPreload = 100000,
						preloadFileSize = 10000,
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					completion = {
						callSnippet = "Replace",
						showParams = true,
					},
					diagnostics = { disable = { "missing-fields" }, delay = 1000, globals = { "vim" } },
				},
			},
		})
	end,
}
