return {
  {
    'stevearc/conform.nvim',
    event = { "LspAttach", "BufReadPost", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "biome", "prettier" },
        typescript = { "biome", "prettier" },
        astro = { "biome", "prettier" },
        vue = { "biome", "prettier" },
        javascriptreact = { "biome", "prettier" },
        typescriptreact = { "biome", "prettier" },
        go = { "gofumpt", "goimports" },
        dart = { "dart_format" },
        yaml = { "yamlfmt" },
        json = { "jq" },
        markdown = { "markdownfmt" },
        sql = { "sleek" },
        templ = { "templ" },
      },
    },
  },

}
