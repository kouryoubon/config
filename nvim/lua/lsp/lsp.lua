require("lsp.lua")
require("lsp.python")
require("lsp.cx")

-- Diagonistics
local sings = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = "󰠠 ",
  [vim.diagnostic.severity.INFO] = " ",
}

vim.diagnostic.config({
  sings = { text = sings },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
})

local default_capabilities = {
  general = {
    positionEncodings = { "utf-16" },
  },
}

local lsp_servers = {
  lua_ls = { capabilities = default_capabilities },
  clangd = { capabilities = default_capabilities },
  -- ruff = { capabilities = default_capabilities },
  pyrefly = { capabilities = default_capabilities },
  basedpyright = { capabilities = default_capabilities },
}
for server, config in pairs(lsp_servers) do
  -- passing config.capabilities to blink.cmp merges with the capabilities in your
  -- `opts[server].capabilities, if you've defined it
  config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
  vim.lsp.config(server, { capabilities = config.capabilities }, true)
  vim.lsp.enable(server)
end
