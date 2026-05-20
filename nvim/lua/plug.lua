-- Bootstrap vim-plug if not installed
local function ensure_vim_plug()
  local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
  if not vim.loop.fs_stat(plug_path) then
    vim.fn.system({
      "curl",
      "-fLo",
      plug_path,
      "--create-dirs",
      "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    })
    print("vim-plug installed. Restart Neovim and run :PlugInstall.")
  end
end

ensure_vim_plug()

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
--Leap
Plug("https://codeberg.org/andyg/leap.nvim")

if not vim.g.vscode then
  -- Completetions
  Plug("onsails/lspkind.nvim")
  Plug("neovim/nvim-lspconfig")
  Plug("rafamadriz/friendly-snippets")
  Plug("saghen/blink.cmp", { ["tag"] = "v1.*" })
  Plug("windwp/nvim-autopairs")
  Plug("L3MON4D3/LuaSnip", { ["tag"] = "v2.*", ["do"] = "make install_jsregexp" })
  Plug("linux-cultist/venv-selector.nvim")
  Plug("stevearc/conform.nvim")
  --Plug('github/copilot.vim')

  --Treesitter for better syntax highlighting
  Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

  --Fuzzy Finder
  Plug("nvim-telescope/telescope.nvim")
  Plug("nvim-lua/plenary.nvim")
  Plug(
    "nvim-telescope/telescope-fzf-native.nvim",
    { ["do"] = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install" }
  )
  Plug("BurntSushi/ripgrep")

  --UI
  Plug("nvim-lualine/lualine.nvim")
  Plug("nvim-tree/nvim-web-devicons")
  Plug("christoomey/vim-tmux-navigator")
  Plug("catppuccin/nvim", { ["as"] = "catppuccin" })

  --File Editor/Explorer
  Plug("stevearc/oil.nvim")
  Plug("MunifTanjim/nui.nvim")
  Plug("nvim-tree/nvim-web-devicons")
  Plug("nvim-neo-tree/neo-tree.nvim", { ["branch"] = "v3.x" })
end
vim.call("plug#end")

require("config.leap")
if not vim.g.vscode then
  require("config.catppuccin")
  require("config.vim-tmux-navigator")
  require("config.blink")
  require("config.auto-pairs")
  require("config.telescope")
  require("config.oil")
  require("config.lualine")
  require("config.conform")
  require("config.venv-selector")
  require("config.treesitter")
  -- require("plugin.floating_terminal")
end
