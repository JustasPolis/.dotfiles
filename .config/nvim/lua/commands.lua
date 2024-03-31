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
    vim.cmd("wincmd p")
    if vim.fn.argv(0) == "." then
      vim.cmd("Alpha")
    end
  end,
})

---@enum MessageType
local message_type = {
  error = 1,
  warn = 2,
  info = 3,
  debug = 4,
}

local function on_message(_, result, ctx)
  ---@type number
  local client_id = ctx.client_id
  local client = vim.lsp.get_client_by_id(client_id)
  local client_name = client and client.name or string.format("lsp id=%d", client_id)

  local message = string.gsub("LSP: (" .. client_name .. ") " .. result.message, "\n", "")
  for level, type in pairs(message_type) do
    if type == result.type then
      vim.notify(message, type, {})
    end
  end
end

vim.lsp.handlers["window/showMessage"] = on_message
