return {
  "nvim-treesitter/nvim-treesitter",
  config = function(_, opts)
    vim.g.ts_update_concurrency = 1
    require("nvim-treesitter.configs").setup(opts)
  end,
  opts = {
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
    ensure_installed = {
      "astro",
      "bash", 
      "c", 
      "css",
      "csv",
      "cue",
      "dhall",
      "dockerfile", 
      "elixir",
      "fish",
      "fsharp",
      "go",
      "hcl",
      "html",
      "json",
      "kdl",
      "latex",
      "lua", 
      "make",
      "markdown",
      "markdown_inline",
      "meson",
      "nickel",
      "ninja",
      "nix",
      "ocaml",
      "pony",
      "python",
      "purescript",
      "roc",
      "rust",
      "scala",
      "scss",
      "solidity",
      "ssh_config",
      "svelte",
      "terraform",
      "todotxt",
      "toml",
      "typescript",
      "typespec",
      "verilog",
      "vue",
      "yaml",
      "zig",
    }
  }
}
