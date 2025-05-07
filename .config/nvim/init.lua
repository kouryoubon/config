-- Bootstrap vim-plug if not installed
local function ensure_vim_plug()
    local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
    if not vim.loop.fs_stat(plug_path) then
        vim.fn.system({
            'curl',
            '-fLo', plug_path,
            '--create-dirs',
            'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
        })
        print("vim-plug installed. Restart Neovim and run :PlugInstall.")
    end
end

ensure_vim_plug()

-- Set leader key
vim.g.mapleader = " "
vim.g.autoformat = true

-- Basic settings
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.updatetime = 100
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- cursor type
vim.o.guicursor = "n-c-sm:ver25,i-ci-ve:ver25,r-cr-o:ver25"

-- Plugin installation section
vim.cmd [[
call plug#begin('~/.vim/plugged')

" LSP Support
Plug 'neovim/nvim-lspconfig'

" Auto Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'github/copilot.vim'

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Treesitter for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" File Explorer
Plug 'nvim-tree/nvim-tree.lua'

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Status Line
Plug 'vim-airline/vim-airline'

" () {} []
Plug 'jiangmiao/auto-pairs'

" Themes
Plug 'catppuccin/nvim', {'as': 'catppuccin' }

" Leap
Plug 'ggandor/leap.nvim'

call plug#end()
]]

-- Leap nvim
require('leap').create_default_mappings()

-- Catppuccin Configuration
require("catppuccin").setup({
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        coc_nvim = true,
    }
})
vim.cmd.colorscheme "catppuccin"

-- copilot.nvim
vim.g.copilot_enabled = false 

-- coc_nvim
vim.g.coc_global_extensions = {
    'coc-snippets', 
    'coc-pyright',
    'coc-clangd',
}

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "python" },
    highlight = { enable = true },
}

-- Enable completion
--vim.o.completeopt = "menuone,noinsert,noselect"

-- Key mappings for autocompletion
local keyset = vim.keymap.set
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

keyset("n", "Q", ":q<CR>", { noremap = true })
keyset("n", "W", ":w<CR>", { noremap = true })
keyset("n", ";", ":", { noremap = true })

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent=true})

-- Highlight the symbol under cursor
vim.cmd([[
  autocmd CursorHold * silent! CocActionAsync('highlight', 'coc-info')
]])

-- nvim-tree Configuration
require('nvim-tree').setup()

-- key mappings
vim.keymap.set('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>tt', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>gs', ':Gitsigns toggle_signs<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<Plug>(coc-definition)', {})
vim.api.nvim_set_keymap('n', '<leader>gr', '<Plug>(coc-references)', {})
vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', {})
vim.api.nvim_set_keymap('n', 'K', ':call CocActionAsync("doHover")<CR>', { silent = true })
-- Key mappings
