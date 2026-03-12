require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
  -- ensure_installed = { "c", "cpp", "python", "lua", "yaml", "ocaml", "rust", "go" },
  highlight = { enable = true },
  auto_install = true,
  autopairs = { enable = true },
  indent = { enable = true, disable = { "ruby" } },
})

require("nvim-treesitter").install({ "cpp", "python", "lua", "yaml", "ocaml", "rust", "go", "toml" })
