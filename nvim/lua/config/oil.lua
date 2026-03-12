require('oil').setup({
  default_file_explorer = true,
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,
  vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open Parent Dir in current widdow" }),
  vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open Parent Dir floating" }),
})
