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

vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup("trouble_buffer_enter"),
  pattern = 'Trouble',
  desc = 'Empty Trouble Buffer',
  callback = function()
    local lines = vim.api.nvim_buf_line_count(0)
    local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local length = string.len(table.concat(content))
    if lines == 1 and length == 0 then
      vim.cmd [[wincmd p]]
    else
      vim.opt.cursorline = true
      vim.cmd [[set termguicolors | hi Cursor blend=100 | set guicursor+=a:Cursor/lCursor]]
    end
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = augroup("trouble_buffer_leave"),
  pattern = 'Trouble',
  desc = 'Cursor line disable',
  callback = function()
    vim.opt.cursorline = false
    vim.cmd [[set termguicolors | hi Cursor blend=0]]
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup("floating_window_leave"),
  callback = function()
    if vim.bo.filetype == 'mason' then
      vim.opt.cursorline = false
      vim.cmd [[set termguicolors | hi Cursor blend=0]]
    elseif vim.bo.filetype == 'lazy' then
      vim.opt.cursorline = false
      vim.cmd [[set termguicolors | hi Cursor blend=0]]
    end
  end,
})


vim.api.nvim_create_autocmd('FileType', {
  group = augroup("floating_file_type"),
  callback = function()
    if vim.bo.filetype == "lazy" then
      vim.opt.cursorline = true
      vim.cmd [[set termguicolors | hi Cursor blend=100 | set guicursor+=a:Cursor/lCursor]]
    elseif vim.bo.filetype == "mason" then
      vim.opt.cursorline = true
      vim.cmd [[set termguicolors | hi Cursor blend=100 | set guicursor+=a:Cursor/lCursor]]
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  group = augroup("rust_silent_write"),
  pattern = '*.rs',
  nested = true,
  callback = function()
    vim.cmd [[silent write]]
  end
})


vim.api.nvim_create_autocmd('User', {
  group = augroup("lsp_progress_update"),
  pattern = { 'LspProgressUpdate' },
  callback = function()
  end,
})


local HEIGHT_RATIO = 0.8

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("help_win", { clear = true }),
  callback = function()
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
    local window_h = screen_h * HEIGHT_RATIO
    local window_h_int = math.floor(window_h)
    local center_x = (screen_w - 81) / 2
    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

    local opts = {
      border = "rounded",
      zindex = 250,
      relative = "editor",
      row = center_y,
      col = center_x,
      width = 81,
      title = "Help",
      title_pos = "center",
      height = window_h_int,
    }
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype == "help" then
      vim.api.nvim_win_set_config(win, opts)
    end
  end
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("rust_save", { clear = true }),
  pattern = "*.rs",
  nested = true,
  callback = function()
    vim.cmd [[silent write]]
  end
})

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
  pattern = { "*.swift", "*.ts", "*.tsx", "*.js" },
  callback = function()
    require("lint").try_lint()
  end
})
