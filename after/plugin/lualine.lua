local lualine = require('lualine')

-- require('lualine').setup {
--   options = {
--     theme = 'tokyonight'
--   },
--   sections = {
--     lualine_c = { {
--       'filename',
--       path = 1,
--     } }
--   }
-- }

local config = {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_c = { {
      'filename',
      path = 1,
    } }
  }
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

ins_left({
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' ',
})

ins_left({
  function()
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
  end,
})

lualine.setup(config)
