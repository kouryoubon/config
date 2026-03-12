vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
  root_markers = { ".clangd", "compile_commands.json" },
  init_options = {
    fallbackFlags = { "-std=c++20" },
  },
  filetype = {
    "c",
    "cpp",
  },
})
