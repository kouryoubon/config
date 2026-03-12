require("catppuccin").setup({
  flavour = "auto",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  term_colors = true,
  show_end_of_buffer = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    gitsigns = true,
    leap = true,
    blink_cmp = {
      style = "bordered"
    },
    telescope = {
      enabled = true,
    },
  },
})

vim.cmd.colorscheme "catppuccin"

vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fe640b", bold = true })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#fe640b", bold = true })
