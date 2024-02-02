local settings = {}

settings["colorscheme"] = "catppuccin"

-- lsp_signature -- 
-- local cfg = {}  -- add your config here
-- require "lsp_signature".setup(cfg)


settings["lsp"] = {
  formatting = {
    format_on_save = true,
  },
}

-- require("mason-lspconfig").setup { 
--   ensure_installed = {
--     "clangd",
--     "gopls",
--     "pyright",
--     "ruff_lsp",
--     "rust_analyzer",
--   },
--   automatic_installation = true,
-- }

return settings
