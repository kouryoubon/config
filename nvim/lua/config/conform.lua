require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end, --some dynamism
    rust = { "rustfmt", lsp_format = "fallback" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    ["_"] = { "codespell" }, -- those aren't configured use this
  },
  format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
})
