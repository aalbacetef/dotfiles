local settings = {}

settings["colorscheme"] = "catppuccin"

settings["lsp"] = {
  formatting = {
    format_on_save = true,
  },
}

settings["options"] = function(local_vim)
  local_vim.opt.wrap = true 
  return local_vim
end


vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx'
  }
})

vim.filetype.add({
  extension = {
    purs = 'purescript'
  }
})


return settings
