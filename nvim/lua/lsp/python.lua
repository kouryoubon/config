-- BasedPyright: for type checking diagnostics, completion is very slow
local root_dir_basedpyright = function(bufnr, cb)
  local root = vim.fs.root(bufnr, {
    "pyproject.toml",
    "pyrifhtconfig.json",
    ".git",
  }) or vim.fn.expand("%:p:h")
  cb(root)
end
vim.lsp.config("basedpyright", {
  filetypes = { "python" },
  cmd = { "basedpyright-langserver", "--stdio" },
  root_dir = root_dir_basedpyright,
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  on_attach = function(client, _)
    -- use pyrefly instead
    client.server_capabilities.hoverProvider = false
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- use ruff
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnkonwMemberType = "none", --ignore warning: cannot infer member type of object like matplot
        },
        typeCheckingMode = "off",
      },
    },
  },
})

-- Pyrefly: completion and semanticTokens
local root_dir_pyrefly = root_dir_basedpyright -- for now same
vim.lsp.config("pyrefly", {
  cmd = { "pyrefly", "lsp" },
  filetypes = { "python" },
  root_dir = root_dir_pyrefly,
  on_attach = function(client, _)
    --use basedpyright instead
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.inlayHintsProvider = false
    client.server_capabilities.referenceProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.hoverProvider = true
  end,
  settings = {},
})

--Ruff: linting and formating
local root_dir_ruff = function(bufnr, cb)
  local root = vim.fs.root(bufnr, {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  }) or vim.fn.expand("%:p:h")
  cb(root)
end

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = root_dir_ruff,
  on_attach = function(client, _)
    --formating
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.hoverProvider = false -- used basedpyright
  end,
  settings = {
    organizeImports = true,
    showSyntaxErrors = true,
    codeAction = {
      disableRuleComment = { enable = false },
      fixViolation = { enable = false },
    },
    lint = {
      enable = true,
    },
  },
})
