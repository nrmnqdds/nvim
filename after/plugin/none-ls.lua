local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.biome.with({
      filetypes = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'typescript', 'typescriptreact' },
      args = {
        'check',
        '--apply-unsafe',
        '--formatter-enabled=true',
        '--linter-enabled=true',
        '--organize-imports-enabled=true',
        '--skip-errors',
        '--stdin-file-path=$FILENAME',
      },
    }),
  },
})
