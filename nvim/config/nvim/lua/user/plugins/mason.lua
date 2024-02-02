return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "autotools_ls", -- makefile
      "bashls",
      "clangd",
      "dockerls",
      -- "eslint", 
      "golangci_lint_ls",
      "gopls",
      "html",
      "julials",
      "pyright",
      "rnix",
      "ruff_lsp",
      "rust_analyzer",
      "solc",
      "terraformls",
      "vtsls",
      "volar",
      "unocss", -- CSS
      "zls", -- zig
    },
  },
}
