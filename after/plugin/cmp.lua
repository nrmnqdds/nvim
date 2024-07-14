require("vim-react-snippets").lazy_load()
local cmp = require("cmp")
local lsp_zero = require("lsp-zero")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'buffer',  keyword_length = 3 },
  },
  formatting = lsp_zero.cmp_format({ details = false }),
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

-- require('cmp').setup({
--   sources = {
--     { name = 'buffer' },
--   },
-- })
--
-- require('cmp').setup {
--   sources = {
--     { name = 'path' }
--   }
-- }
--
-- require('cmp').setup {
--   sources = {
--     { name = 'nvim_lua' }
--   }
-- }
