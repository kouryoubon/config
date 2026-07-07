-- Basic settings (no termguicolors — safe for poor terminals)
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.updatetime = 300
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight momentarily when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
