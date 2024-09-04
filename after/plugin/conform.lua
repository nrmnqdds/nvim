require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    -- Conform will run multiple formatters sequentially
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "biome", stop_after_first = true },
    go = { "gofumpt", "gofmt" },
  },
})
