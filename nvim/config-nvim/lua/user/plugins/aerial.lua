
-- needed so that symbol outline works on large files
max_lines = 10000 -- 10k lines
max_size = 20 * 1024 * 1024 -- 20 MB

return {
    "stevearc/aerial.nvim",
    event = "User AstroFile",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      disable_max_lines = max_lines or vim.g.max_file.lines,
      disable_max_size = max_size or vim.g.max_file.size,
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
}
