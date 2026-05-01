vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').vyper = {
      install_info = {
        url = "https://github.com/madlabman/tree-sitter-vyper",
        branch = "master",
      },
      filetype = "vyper",
    }
  end,
})
