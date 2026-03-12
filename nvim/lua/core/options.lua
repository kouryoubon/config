if not vim.g.vscode then
  vim.g.mapleader = " "
  vim.g.autoformat = true

  -- Basic settings
  vim.opt.clipboard = "unnamedplus"
  vim.opt.signcolumn = "yes"
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.softtabstop = 4
  vim.opt.tabstop = 4
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  vim.opt.termguicolors = true
  vim.opt.cursorline = true
  vim.opt.updatetime = 100
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.hlsearch = true
  vim.opt.updatetime = 300
  vim.opt.signcolumn = "yes"
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undofile = true
  vim.opt.wrap = true
  vim.opt.scrolloff = 8
  vim.opt.incsearch = true
  vim.opt.inccommand = "split"

  -- cursor type
  vim.o.guicursor = "n-c-sm:ver25,i-ci-ve:ver25,r-cr-o:ver25"

  -- python
  vim.g.python3_host_prog = "~/.local/share/uv/tools/pynvim/bin/python"
end
