local ok, neo_tree = pcall(require, "neo-tree")
if not ok then
  return
end

neo_tree.setup({
  sources = {
    "filesystem",
    "buffers",
    "git_status",
  },
  close_if_last_window = true,
  enable_diagnostics = true,
  enable_git_status = true,
  sort_case_insensitive = true,
  popup_border_style = "rounded",
  source_selector = {
    winbar = true,
    statusline = false,
    content_layout = "center",
    tabs_layout = "equal",
    sources = {
      { source = "filesystem", display_name = " Files " },
      { source = "buffers", display_name = " Buffers " },
      { source = "git_status", display_name = " Git " },
    },
  },
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      with_expanders = true,
      expander_collapsed = ">",
      expander_expanded = "v",
    },
    git_status = {
      symbols = {
        added = "A",
        deleted = "D",
        modified = "M",
        renamed = "R",
        untracked = "?",
        ignored = "I",
        unstaged = "U",
        staged = "S",
        conflict = "!",
      },
    },
  },
  window = {
    position = "left",
    width = 34,
    mappings = {
      ["h"] = "close_node",
      ["l"] = "open",
      ["o"] = "open",
      ["<space>"] = "none",
    },
  },
  filesystem = {
    bind_to_cwd = true,
    cwd_target = {
      sidebar = "tab",
      current = "window",
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      },
      never_show = {
        ".git",
      },
    },
    group_empty_dirs = true,
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ["H"] = "toggle_hidden",
        ["."] = "set_root",
        ["<bs>"] = "navigate_up",
      },
    },
  },
  buffers = {
    bind_to_cwd = true,
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    group_empty_dirs = true,
    show_unloaded = true,
  },
})

vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle filesystem left<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader>nf", "<cmd>Neotree reveal filesystem left<CR>", { desc = "Reveal file in Neo-tree" })
vim.keymap.set("n", "<leader>nb", "<cmd>Neotree toggle buffers left<CR>", { desc = "Neo-tree buffers" })
vim.keymap.set("n", "<leader>ng", "<cmd>Neotree toggle git_status float<CR>", { desc = "Neo-tree git status" })
