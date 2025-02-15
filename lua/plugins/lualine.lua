return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      local client_lsp = function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_get_option_value('filetype', {
          buf = 0
        })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          -- local filetypes = client.config.get_language_id(bufnr, buf_ft)
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end

      -- fixed deprecated but not working ffs
      --   -- Lsp server name .
      --   local client_lsp = function()
      --     local msg = 'No Active Lsp'
      --     -- local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype') -- deprecated
      --     local buf_ft = vim.api.nvim_get_option_value('filetype', {
      --       buf = 0
      --     })
      --     local clients = vim.lsp.get_clients()
      --     if next(clients) == nil then
      --       return msg
      --     end
      --     for _, client in ipairs(clients) do
      --       local filetypes = client.config.get_language_id
      --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      --         return client.name
      --       end
      --     end
      --     return msg
      --   end,

      local client_fmt = function()
        -- Check if 'conform' is available
        local status, conform = pcall(require, 'conform')
        if not status then
          return 'Conform not installed'
        end

        local lsp_format = require('conform.lsp_format')

        -- Get formatters for the current buffer
        local formatters = conform.list_formatters_for_buffer()
        if formatters and #formatters > 0 then
          local formatterNames = {}

          for _, formatter in ipairs(formatters) do
            table.insert(formatterNames, formatter)
          end

          return '󰷈 ' .. table.concat(formatterNames, ' ')
        end

        -- Check if there's an LSP formatter
        local bufnr = vim.api.nvim_get_current_buf()
        local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })

        if not vim.tbl_isempty(lsp_clients) then
          return '󰷈 LSP Formatter'
        end

        return ''
      end

      local config = {
        options = {
          theme = 'tokyonight'
          -- theme = 'github_dark_default'
        },
        sections = {
          lualine_c = { {
            'filename',
            path = 1,
          } },
          lualine_x = { 'filetype' },
          lualine_y = {
            {
              client_lsp,
              color = { fg = '#7aa2f7', gui = 'bold' },
              icon = '',
            },
            {
              client_fmt,
              color = { fg = '#7aa2f7', gui = 'bold' },
            }
          },
          lualine_z = {},
        }
      }

      require('lualine').setup(config)
    end
  },

}
