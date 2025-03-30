return {
  -- {
  --   "mfussenegger/nvim-lint",
  --   cmd = { "Lint", "LintWithBiome", "LintWithEslint" },
  --   config = function()
  --     require("lint").linters = {
  --       ---@diagnostic disable-next-line: missing-fields
  --       biomejs = {
  --         condition = function(ctx)
  --           return vim.fs.find({ "biome.json" }, { path = ctx.filename, updward = true })[1]
  --         end,
  --       },
  --       ---@diagnostic disable-next-line: missing-fields
  --       eslint = {
  --         condition = function(ctx)
  --           return vim.fs.find(
  --             { ".eslintrc.cjs", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.js" },
  --             { path = ctx.filename, updward = true }
  --           )[1]
  --         end,
  --       },
  --       ---@diagnostic disable-next-line: missing-fields
  --       luacheck = {
  --         condition = function(ctx)
  --           return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, updward = true })[1]
  --         end,
  --       },
  --     }
  --
  --     require("lint").linters_by_ft = {
  --       javascript = { "biomejs", "eslint" },
  --       javascriptreact = { "biomejs", "eslint" },
  --       lua = { "luacheck" },
  --       typescript = { "biomejs", "eslint" },
  --       typescriptreact = { "biomejs", "eslint" },
  --       svelte = { "biomejs", "eslint" },
  --       vue = { "biomejs", "eslint" },
  --     }
  --
  --     -- write logic to handle... getting nearest linter by filetype...
  --     -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  --     --
  --     -- vim.api.nvim_create_autocmd({
  --     --   "BufReadPost",
  --     --   "BufWritePost",
  --     --   "InsertLeave",
  --     -- }, {
  --     --   group = lint_augroup,
  --     --   callback = function()
  --     --     require("lint").try_lint()
  --     --   end,
  --     -- })
  --
  --     vim.api.nvim_create_user_command("Lint", function()
  --       require("lint").try_lint()
  --     end, {})
  --
  --     vim.api.nvim_create_user_command("LintWithBiome", function()
  --       require("lint").try_lint("biomejs")
  --     end, {})
  --
  --     vim.api.nvim_create_user_command("LintWithEslint", function()
  --       require("lint").try_lint("eslint")
  --     end, {})
  --   end
  -- },
}
