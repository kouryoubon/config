vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "Q", ":q<CR>", { noremap = true })
vim.keymap.set("n", "W", ":w<CR>", { noremap = true })
vim.keymap.set("n", ";", ":", { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- indents
vim.keymap.set("n", "<Tab>", ">>", { silent = true, desc = "Indentation" })
vim.keymap.set("n", "<S-Tab>", "<<", { silent = true, desc = "Unindentation" })
vim.keymap.set("v", "<Tab>", ">gv", { silent = true, desc = "Indentation" })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true, desc = "Unindentation" })

if not vim.g.vscode then
  local terminal_buffer = nil
  local function compile_run()
    local run_cmd = {
      cpp = "clang++ -std=c++17 %s -o %s && ./%s",
      c = "clang %s -o %s && ./%s",
      python = "python %s",
    }
    vim.cmd("w")

    local ft = vim.bo.filetype
    local template = run_cmd[ft]
    if not template then
      vim.notify("No compile or run commands for current filetype: " .. ft, vim.log.levels.ERROR)
      return nil
    end

    local file = vim.fn.expand("%")
    local output = vim.fn.expand("%:r")

    local compile_run_commands = nil
    if ft == "python" then
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

  -- KeyMappings
  vim.keymap.set("n", "<F5>", compile_run, { silent = true }) -- Compile/Run
  vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true }) -- Esc to exit terminal mode

  -- this conflicts with defaults, so maybe use <leader>n/p
  -- vim.keymap.set("n", "N", "<cmd>cnext<CR>", { silent = true, desc = "Jump to the next item in quickfix lists" })
  -- vim.keymap.set("n", "P", "<cmd>cprev<CR>", { silent = true, desc = "Jump to the next item in quickfix lists" })

  -- Moving between windows / use navigator plugins
  -- vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
  -- vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
  -- vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
  -- vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Centered" })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Centered" })

  -- Resize with arrows
  vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { silent = true })
  vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { silent = true })
  vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { silent = true })
  vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { silent = true })

  -- Navigate buffers
  vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })
  vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })

  -- Better terminal navigation
  local term_opts = { silent = true }
  vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
  vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
  vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
  vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

  -- Source the configs / run the line, block lua code
  vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
  vim.keymap.set("n", "<leader>x", ":.lua<CR>")
  vim.keymap.set("v", "<leaeder>x", ":lua<CR>")
end
