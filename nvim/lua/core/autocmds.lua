-- Yank Highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight momentarily when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

if not vim.g.vscode then
  -- For snippets file
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "snippets",
    callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.foldenable = false
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })

  -- LSP
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
      ---@diagnostic disable-next-line: undefined-field
      local opts = { buffer = args.buffer, silent = true }

      opts.desc = "Show LSP references"
      -- vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)

      opts.desc = "Go to definitions"
      -- vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

      opts.desc = "Go to decleration"
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.decleration()<CR>", opts)

      opts.desc = "Show LSP implementations"
      -- vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_defintion()<CR>", opts)

      opts.desc = "Show signature help"
      vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()CR>", opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", "<cmd>vim.lsp.buf.hover()<CR>", opts)

      opts.desc = "Diagnostics"
      vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      vim.diagnostic.config({
        virtual_text = true,
      })

      opts.desc = "Show buffer diagnostics"
      vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show line diagnostics floating window"
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

      opts.desc = "Toggle diagnostics"
      vim.keymap.set("n", "<leader>td", function()
        local diag_status = 1 -- 1 means on, 0 means off
        return function()
          if diag_status == 1 then
            diag_status = 0
            vim.diagnostic.config({
              underline = false,
              virtual_text = false,
              signs = false,
              update_in_insert = false,
            })
          else
            diag_status = 1
            vim.diagnostic.config({
              underline = true,
              virtual_text = true,
              signs = true,
              update_in_insert = true,
            })
          end
        end
      end, opts)

      opts.desc = "Show function's signature in insert mode"
      vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, opts)

      opts.desc = "Show code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      -----------------------
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return nil
      end

      -- code foding
      if client and client:supports_method("textDocument/foldingRange") then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end

      -- toggle inlay hints
      opts.desc = "Toggle Inlay hints"
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set("n", "<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
        end, opts)
      end

      opts.desc = "Highlight words under curosr"
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup("Lsphight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = args.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = args.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
else
  vim.keymap.set("n", "<Space>", "", { noremap = true, silent = true })
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  vim.keymap.set(
    "n",
    "<leader>gd",
    "<cmd>lua require('vscode').action('workbench.action.revealDefintion')<CR>",
    { desc = "VScode Go to Definition" }
  )
end
