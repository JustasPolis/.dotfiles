local function augroup(name)
	return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	group = augroup("rust_silent_write"),
	pattern = "*.rs",
	nested = true,
	callback = function()
		vim.cmd([[silent write]])
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
	pattern = { "*.swift", "*.ts", "*.tsx", "*.js", "*.fish", "*.nix" },
	callback = function()
		require("lint").try_lint()
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("help_enter", { clear = true }),
	pattern = "*",
	callback = function(event)
		if vim.bo[event.buf].filetype == "help" then
			vim.bo[event.buf].buflisted = true
			vim.cmd.only()
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("config_vim_enter", { clear = true }),
	once = true,
	callback = function()
		vim.cmd("Trouble")
		vim.cmd("wincmd p")
		if vim.fn.argv(0) == "." then
			vim.cmd("Alpha")
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("noice_message", { clear = true }),
	pattern = "NoiceMessage",
	callback = function()
		--vim.cmd("NoiceHistory")
	end,
})

local function copy(table)
	local orig_type = type(table)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(table) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = table
	end
	return copy
end

local event = require("nui.utils.autocmd").event

local cmp = require("cmp")
local cmp_config = require("cmp.config")

local Input = require("nui.input")

local input = Input({
	position = "50%",
	size = {
		width = "50%",
	},
	border = {
		style = "rounded",
		padding = {
			left = 1,
		},
		text = {
			top = "Command",
			top_align = "center",
		},
	},
}, {
	prompt = "",
	default_value = "",
	on_close = function()
		print("Input Closed!")
	end,
	on_submit = function(value)
		vim.cmd(value)
	end,
})

vim.ui_attach(vim.api.nvim_create_namespace("redirect messages"), { ext_cmdline = true }, function(event, ...)
	if event == "cmdline_show" then
		input:mount()
	elseif event == "cmdline_hide" then
		input:unmount()
	end
	--if event == "msg_show" then
	--	local level = vim.log.levels.INFO
	--	local kind, content = ...
	--	if string.find(kind, "err") then
	--		level = vim.log.levels.ERROR
	--	end
	--	vim.notify(content, level, { title = "Message" })
	--end
end)

--local cmdline_config = Util.copy(cmp_config.cmdline[":"])
--cmdline_config.enabled = true
--cmp.setup.buffer(cmdline_config)
