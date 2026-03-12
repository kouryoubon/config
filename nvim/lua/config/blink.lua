local lspkind = require("lspkind")

require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = lspkind.symbol_map[ctx.kind] or ""
              return icon .. (ctx.icon_gap or "")
            end,
          },
        },
      },
    },
  },
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      snippets = { score_offset = 1000 },
    },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
  signature = {
    enabled = true,
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
})
