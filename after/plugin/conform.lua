require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "biome", "prettier" },
    typescript = { "biome", "prettier" },
    vue = { "volar" },
    javascriptreact = { "biome", "prettier" },
    typescriptreact = { "biome", "prettier" },
    go = { "gofumpt", "gofmt" },
    dart = { "dart_format", "dcm_format" },
    yaml = { "yamlfmt" },
    json = { "jq" },
    markdown = { "markdownfmt" },
  },
})
