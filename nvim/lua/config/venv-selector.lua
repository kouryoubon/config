require("venv-selector").setup({
  name = { "venv", ".venv", "env" },
  auto_refresh = true,
})
vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<CR>", { desc = "Select python virtualenv" })
