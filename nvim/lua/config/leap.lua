vim.keymap.set({"n", "x","o"}, "s", "<Plug>(leap-forward)", {desc = "Leap forward to target"})
vim.keymap.set({"n", "x","o"}, "S", "<Plug>(leap-backward)", {desc = "Leap backward to target"})
vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", {desc = "Leap from window"})