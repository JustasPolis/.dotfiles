return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	lazy = false,
	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug continue",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Debug terminate",
		},
	},
	config = function()
		local dap_ui = require("dapui")
		---@diagnostic disable-next-line: missing-fields
		dap_ui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			layouts = {
				{
					elements = {
						{
							id = "scopes",
							size = 0.25,
						},
						{
							id = "breakpoints",
							size = 0.25,
						},
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "watches",
							size = 0.25,
						},
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{
							id = "console",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 5,
				},
				{
					elements = {
						{
							id = "repl",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 5,
				},
			},
		})
		local dap = require("dap")
		dap.adapters.codelldb_swift = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = {
					"--port",
					"${port}",
					"--liblldb",
					"/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
					"--settings",
					'{"evaluateForHovers":true,"commandCompletions":true,"sourceLanguages":["swift"]',
				},
			},
		}

		dap.configurations.swift = {
			{
				name = "lldb_swift",
				type = "codelldb_swift",
				request = "launch",
				program = function()
					return vim.fn.getcwd() .. "/.build/debug/testExecutable"
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				expressions = "native",
				args = {
					"--settings",
					'{"evaluateForHovers":true,"commandCompletions":true,"sourceLanguages":["swift"]',
				},
			},
		}
	end,
}
