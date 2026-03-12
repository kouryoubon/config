local root_dir_lua = function(bufnr, cb)
  local root = vim.fs.root(bufnr, {
    "luarc.json",
    ".luarc.json",
    ".git",
  }) or vim.fn.expand("%:p:h")
  cb(root)
end

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  root_dir = root_dir_lua,
  fietypes = { "lua" },
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
        showWord = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
    },
  },
})
