vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx'
  }
})

vim.filetype.add({
  extension = {
    purs = 'purescript',
    ncl = 'nickel'
  }
})


return {
  -- load my config
  { import = "user.plugins" },

  -- ensure wrapping is enabled
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.options.opt.wrap = true
      return opts
    end
  },
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.formatting.format_on_save.enabled = true
      return opts
    end
  },
}
