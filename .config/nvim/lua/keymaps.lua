local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)

keymap("n", "<leader>|", ":vnew <cr>", opts)
keymap("n", "gb", "<C-o>", opts)

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<C-i>", ':let@/=""<CR>', opts)

keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("n", "<C-m>", "*``cgn", opts)

keymap("n", "<leader>a", ":wqa<CR>", opts)
keymap("n", "<leader>o", ":normal o<CR>", opts)
keymap("n", "<leader>O", ":normal O<CR>", opts)
keymap("n", "<C-w>", ":silent write<CR>", opts)

vim.keymap.set("n", "<C-1>", function()
	require("bufferline").go_to(1, true)
end, opts)

vim.keymap.set("n", "<C-2>", function()
	require("bufferline").go_to(2, true)
end, opts)

vim.keymap.set("n", "<C-3>", function()
	require("bufferline").go_to(3, true)
end, opts)

vim.keymap.set("n", "<C-4>", function()
	require("bufferline").go_to(4, true)
end, opts)

vim.keymap.set("n", "<C-5>", function()
	require("bufferline").go_to(5, true)
end, opts)

vim.keymap.set("n", "<C-6>", function()
	require("bufferline").go_to(6, true)
end, opts)

vim.keymap.set("n", "<C-7>", function()
	require("bufferline").go_to(7, true)
end, opts)

vim.keymap.set("n", "<C-8>", function()
	require("bufferline").go_to(8, true)
end, opts)

vim.keymap.set("n", "<C-9>", function()
	require("bufferline").go_to(9, true)
end, opts)
