return {
  {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    dependencies = {
      -- LSP Support
      {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "neovim/nvim-lspconfig",
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        -- "angularls", -- NOTE: disabled for now. @see https://github.com/neovim/nvim-lspconfig/issues/3593
        "astro",
        "cssls",
        -- "cssmodules_ls",
        "dockerls",
        -- "emmet_language_server",
        "eslint", -- NOTE: should probably add the root util...
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "prismals",
        "tailwindcss",
        "ts_ls",
        "yamlls",
        "biome",
        "marksman"
      }

      require("mason").setup({
        ui = { border = "rounded" },
      })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = servers,
      })

      vim.cmd("hi! link MasonNormal Normal")

      -- Use builtin LSP hover handler with rounded border
      -- See: https://github.com/neovim/nvim-lspconfig/issues/3036#issuecomment-2315035246
      local _handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      local lsp = require("lspconfig")

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            handlers = _handlers,
          })
        end,
        ["cssls"] = function()
          lsp.cssls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            settings = {
              css = {
                lint = {
                  -- fixes unknown @tailwind rule for css files
                  unknownAtRules = "ignore",
                },
              },
              scss = {
                lint = {
                  -- fixes unknown @tailwind rule for sass files
                  unknownAtRules = "ignore",
                },
              },
            },
          })
        end,
        ["yamlls"] = function()
          lsp.jsonls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            settings = {
              json = {
                schemaStore = {
                  -- You must disable built-in schemaStore support if you want to use
                  -- this plugin and its advanced options like `ignore`.
                  enable = false,
                  -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                  url = "",
                },
                schemas = require('schemastore').yaml.schemas(),
              },
              format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
              },
              validate = { enable = true },
            },
          })
        end,
        ["jsonls"] = function()
          -- NOTE: to add new schemas, find url here https://www.schemastore.org/json/
          lsp.jsonls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            settings = {
              json = {
                schemaStore = {
                  -- You must disable built-in schemaStore support if you want to use
                  -- this plugin and its advanced options like `ignore`.
                  enable = false,
                  -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                  url = "",
                },
                schemas = require('schemastore').json.schemas(),
              },
              format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
              },
              validate = { enable = true },
            },
          })
        end,
        ["gopls"] = function()
          lsp.gopls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                completeUnimported = true,
                usePlaceholders = true,
              },
            },
          })
        end,
        ["lua_ls"] = function()
          lsp.lua_ls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                diagnostic = {
                  globals = { "vim" },
                  disable = { "missing-fields", "incomplete-signature-doc" },
                }
              },
            },
          })
        end,
        ["ts_ls"] = function()
          require("lspconfig").ts_ls.setup({
            capabilities = capabilities,
            handlers = _handlers,
            init_options = {
              preferences = {
                importModuleSpecifierPreference = "non-relative",
              },
            },
          })
        end,
      })
    end
  },

  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require('tiny-code-action').setup({
        backend = "delta"
      })
    end
  },
}
