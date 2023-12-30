return {
	"mikesmithgh/kitty-scrollback.nvim",
	enabled = true,
	lazy = true,
	cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
	event = { "User KittyScrollbackLaunch" },
	config = function()
		require("kitty-scrollback").setup()
	end,
	build = function()
		local source = vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim"
		local target = "~/.config" .. "/kitty"
		local command = string.format("ln -s '%s' '%s'", source, target)
		os.execute(command)
	end,
}
