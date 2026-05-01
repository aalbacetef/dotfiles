vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx',
    purs = 'purescript',
    ncl = 'nickel',
  }
})

-- add vyper-lsp plugin 
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.vy" },
  callback = function()
    vim.lsp.start({
      name = "vyper-lsp",
      cmd = { "vyper-lsp" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1])
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.vy" },
  callback = function()
    vim.lsp.start({
      name = "vyper-lsp",
      cmd = { "vyper-lsp" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1])
    })
  end,
})

vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
--- done


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
      vim.lsp.log.set_level("debug")
      opts.formatting.format_on_save.enabled = true
      -- configure vtsls for ts/js and vue files
      opts.config.vtsls = {
        filetypes = { 
          "javascript", 
          "javascriptreact", 
          "typescript", 
          "typescriptreact", 
          "vue",
         },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                },
              },
            },
          },
        },
      }
      -- configure volar with the request forwarding handler
      opts.config.volar = {
        filetypes = { "vue" },
        on_init = function(client)
          client.handlers["tsserver/request"] = function(_, result, context)
            local ts_clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
            if #ts_clients == 0 then return end
            local ts_client = ts_clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              command = "typescript.tsserverRequest",
              arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
              local response = r and r.body
              local response_data = { { id, response } }
              client:notify("tsserver/response", response_data)
            end)
          end
        end,
      }

      return opts
    end,
  },
}
