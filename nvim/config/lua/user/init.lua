vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx',
    purs = 'purescript',
    ncl = 'nickel',
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
