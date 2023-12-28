local function contains(list, item)
	for _, val in ipairs(list) do
		if item == val then
			return true
		end
	end
	return false
end

local function process_cargo_artifact(artifact)
	local ok, dap = pcall(require, "dap")
	if not ok then
		vim.notify("Nvim-Dap is missing", vim.log.levels.TRACE)
		do
			return
		end
	end

	local executables = {}

	local is_binary = contains(artifact.target.crate_types, "bin")
	local is_build_script = contains(artifact.target.kind, "custom-build")
	local is_test = ((artifact.profile.test == true) and (artifact.executable ~= nil))
		or contains(artifact.target.kind, "test")
	if (is_binary and not is_build_script) or is_test then
		table.insert(executables, artifact.executable)
	end
	if #executables <= 0 then
		vim.notify("No executable found.", vim.log.levels.TRACE)
	end
	if #executables > 1 then
		vim.notify("Multiple executables are not supported.", vim.log.levels.TRACE)
	end

	vim.schedule(function()
		dap.adapters.codelldb_rust = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = {
					"--port",
					"${port}",
				},
			},
		}

		local config = {
			name = "Rust Debug",
			type = "codelldb_rust",
			request = "launch",
			program = executables[1],
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		}

		require("dapui").open({ layout = 2 })
		require("dap.ext.autocompl").attach()
		dap.run(config)
	end)
end

local function start_cargo(opts)
	local command = opts.fargs[1]
	if command ~= "run" and command ~= "test" then
		vim.notify("Command unsupported.", vim.log.levels.TRACE)
		return
	end
	vim.fn.jobstart({ "cargo", "build", "--message-format=json" }, {
		cwd = vim.loop.cwd(),
		on_stdout = function(_, data)
			if type(data) ~= "table" then
				vim.notify("An error occurred while compiling rust executable.", vim.log.levels.TRACE)
			end
			local artifact = vim.fn.json_decode(data[1])
			local status = vim.fn.json_decode(data[2])
			if
				artifact ~= nil
				and artifact.reason == "compiler-artifact"
				and status ~= nil
				and status.reason == "build-finished"
				and status.success == true
			then
				process_cargo_artifact(artifact)
			else
				vim.notify("An error occurred while compiling rust executable.", vim.log.levels.TRACE)
			end
		end,
		stdout_buffered = true,
	})
end

vim.api.nvim_create_user_command("Cargo", start_cargo, {
	nargs = 1,
	complete = function()
		return { "test", "run" }
	end,
})

vim.api.nvim_create_user_command("ConsoleToggle", function()
	local dap = require("dapui")
	dap.toggle({ layout = 2 })
end, {})

vim.api.nvim_create_user_command("ReplToggle", function()
	local dap = require("dapui")
	dap.toggle({ layout = 3 })
end, {})
