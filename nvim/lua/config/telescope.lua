require("telescope").setup({
  pickers = {
    find_files = {
      theme = "ivy",
    },
  },
  extensions = {
    fzf = {},
  },
})

require("telescope").load_extension("fzf")
--multigrep self defined
--for grep: something + 2 spaces + additional filter
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local multigrep = function(opts)
  opts = opts or {}
  --diagnostic disable-next-line: undefined-field
  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end
      args = { args, "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      return vim.iter(args):flatten():totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", multigrep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>en", function()
  builtin.find_files({
    cwd = vim.fn.stdpath("config"),
  })
end, { desc = "Edit Neovim config files" })
vim.keymap.set("n", "<leader>ep", function()
  builtin.find_files({
    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "plugged"),
  })
end, { desc = "Edit/See installed plugins's internals" })
vim.keymap.set("n", "<leader>ew", function()
  builtin.find_files({
    cwd = vim.fn.getcwd(),
  })
end, { desc = "Edit/See current workspace's files" })
