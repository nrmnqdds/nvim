local lsp = require('lspconfig')

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- lsp_zero.on_attach(function(client, bufnr)
--   local opts = { buffer = bufnr, remap = false }
--
--   vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--   vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--   vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--   vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--   vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--   vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--   vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--   vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
--   vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--   -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- end)

local on_attach = function(client, bufnr)
  --- toggle diagnostics
  vim.g.diagnostics_visible = true
  local function toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.diagnostic.enable(false)
    else
      vim.g.diagnostics_visible = true
      vim.diagnostic.enable()
    end
  end

  --- autocmd to show diagnostics on CursorHold
  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer = bufnr,
  --   desc = "✨lsp show diagnostics on CursorHold",
  --   callback = function()
  --     local hover_opts = {
  --       focusable = false,
  --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  --       border = "rounded",
  --       source = "always",
  --       prefix = " ",
  --     }
  --     vim.diagnostic.open_float(nil, hover_opts)
  --   end,
  -- })

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "✨lsp hover for docs" }))

  vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, vim.tbl_extend("force", bufopts, { desc = "✨lsp show diagnostics" }))

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
  end, vim.tbl_extend("force", bufopts, { desc = "✨lsp go to next diagnostic" }))

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
  end, vim.tbl_extend("force", bufopts, { desc = "✨lsp go to previous diagnostic" }))

  vim.keymap.set(
    "n",
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp go to definition" })
  )

  vim.keymap.set(
    "n",
    "gt",
    function()
      vim.lsp.buf.type_definition()
    end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp go to type definition" })
  )

  vim.keymap.set(
    "n",
    "gi",
    function()
      vim.lsp.buf.implementation()
    end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp go to implementation" })
  )

  vim.keymap.set("n", "<leader>vr", function()
    vim.lsp.buf.rename()
  end, vim.tbl_extend("force", bufopts, { desc = "✨lsp rename" }))

  vim.keymap.set(
    "n",
    "gr",
    function()
      vim.lsp.buf.references()
    end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp go to references" })
  )

  vim.keymap.set(
    "n",
    "<leader>l",
    function()
      toggle_diagnostics()
    end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp toggle diagnostics" })
  )
  vim.keymap.set(
    "n",
    "<leader>a",
    function() vim.lsp.buf.code_action() end,
    vim.tbl_extend("force", bufopts, { desc = "✨lsp code action" })
  )
end

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'rust_analyzer',
    'biome',
    'tailwindcss',
    'volar',
    'yamlls',
    'lua_ls',
    'gopls',
    'prismals'
  },
})

require('lspconfig').tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = function(
        _,
        result,
        ctx,
        config
    )
      if result.diagnostics == nil then
        return
      end

      -- ignore some tsserver diagnostics
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]

        local formatter = require('format-ts-errors')[entry.code]
        entry.message = formatter and formatter(entry.message) or entry.message

        -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        if entry.code == 80001 then
          -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(
        _,
        result,
        ctx,
        config
      )
    end,
  },
})
lsp.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.biome.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.volar.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.prismals.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lsp.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
})
lsp.yamlls.setup({
  capabilities = capabilities,
  on_attach = function(client, buffer)
    if client.name == "yamlls" then
      client.resolved_capabilities.document_formatting = true
    end
  end,

  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.*",
        ["https://json.schemastore.org/catalog-info.json"] = ".backstage/*.yaml",
        ["https://raw.githubusercontent.com/iterative/dvcyaml-schema/master/schema.json"] = "**/dvc.yaml",
        ["https://json.schemastore.org/swagger-2.0.json"] = "**/swagger.yaml",
      },
    },
  },
})

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    source = true,
    prefix = "●",
  },
  underline = true,
  signs = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- local icons = require("utils").icons
local icons = {
  diagnostics = { Error = "✘", Warn = "", Hint = "i", Info = "i" },
  git = {
    Add = "+",
    Change = "~",
    Delete = "-",
  },
  kinds = {
    Array = "󰅪",
    Branch = "",
    Boolean = "◩",
    Class = "󰠱",
    Color = "󰏘",
    Constant = "󰏿",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "󰆨",
    File = "󰈙",
    Folder = "󰉋",
    Function = "ƒ",
    Interface = "",
    Key = "",
    Keyword = "󰌋",
    Method = "󰆧",
    Module = "󰏗 ",
    Namespace = "󰅩",
    Number = "󰎠",
    Null = "󰟢",
    Object = "⦿",
    Operator = "+",
    Package = "󰏗",
    Property = "󰜢",
    Reference = "",
    Snippet = "",
    String = "𝓐",
    Struct = "",
    Text = "",
    TypeParameter = "󰆩",
    Unit = "",
    Value = "󰎠",
    Variable = "󰀫",
  },
  cmp_sources = {
    nvim_lsp = "✨",
    luasnip = "🚀",
    buffer = "📝",
    path = "📁",
    cmdline = "💻",
  },
  statusline = {
    Error = "❗",
    Warn = "⚠️ ",
    Hint = "i",
    Info = "💡",
  },
}

for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
  vim.fn.sign_define(
    "DiagnosticSign" .. type,
    { name = "DiagnosticSign" .. type, text = icons.diagnostics[type], texthl = "Diagnostic" .. type }
  )
end

require("lspconfig.ui.windows").default_options.border = "rounded"
