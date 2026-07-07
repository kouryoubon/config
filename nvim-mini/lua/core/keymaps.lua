vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basics
vim.keymap.set("n", "Q", ":q<CR>", { noremap = true })
vim.keymap.set("n", "W", ":w<CR>", { noremap = true })
vim.keymap.set("n", ";", ":", { noremap = true })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move lines up" })

-- Indent / unindent
vim.keymap.set("n", "<Tab>", ">>", { silent = true, desc = "Indent" })
vim.keymap.set("n", "<S-Tab>", "<<", { silent = true, desc = "Unindent" })
vim.keymap.set("v", "<Tab>", ">gv", { silent = true, desc = "Indent" })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true, desc = "Unindent" })

-- Compile / run
local terminal_buffer = nil
local function compile_run()
  local run_cmd = {
    cpp = "clang++ -std=c++17 %s -o %s && ./%s",
    c = "clang %s -o %s && ./%s",
    python = "python %s",
    rust = "rustc %s -o %s && ./%s",
    go = "go run %s",
  }
  vim.cmd("w")

  local ft = vim.bo.filetype
  local template = run_cmd[ft]
  if not template then
    vim.notify("No compile or run commands for filetype: " .. ft, vim.log.levels.ERROR)
    return nil
  end

  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")

  local compile_run_commands = nil
  if ft == "python" or ft == "go" then
    compile_run_commands = string.format(template, file)
  else
    compile_run_commands = string.format(template, file, output, output)
  end

  if not terminal_buffer or not vim.api.nvim_buf_is_valid(terminal_buffer) then
    vim.cmd("split | terminal")
    terminal_buffer = vim.api.nvim_get_current_buf()
  else
    vim.cmd("split")
    vim.api.nvim_set_current_buf(terminal_buffer)
  end

  vim.fn.chansend(vim.b.terminal_job_id, "clear\n")
  vim.fn.chansend(vim.b.terminal_job_id, compile_run_commands .. "\n")
end

vim.keymap.set("n", "<F5>", compile_run, { silent = true, desc = "Compile / Run" })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true, desc = "Exit terminal mode" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Scroll down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Scroll up (centered)" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Go to right window" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { silent = true, desc = "Resize up" })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { silent = true, desc = "Resize down" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { silent = true, desc = "Resize left" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { silent = true, desc = "Resize right" })

-- Buffer navigation
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Terminal-mode window navigation
local term_opts = { silent = true }
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Source / run Lua
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current line as Lua" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run selection as Lua" })

-- Built-in LSP keymaps (work with any LSP, no plugin required)
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true, desc = "Go to definition" })
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { silent = true, desc = "Go to declaration" })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { silent = true, desc = "Show references" })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true, desc = "Show implementations" })
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { silent = true, desc = "Show type definition" })
vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true, desc = "Signature help" })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, desc = "Smart rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Code actions" })
vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true, desc = "Line diagnostics" })
vim.keymap.set("i", "<C-h>", function()
  vim.lsp.buf.signature_help()
end, { silent = true, desc = "Signature help (insert)" })

-- Folding
vim.keymap.set("n", "<CR>", "za", { desc = "Toggle fold under cursor" })
