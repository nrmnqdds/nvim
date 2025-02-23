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
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
    },
    config = function()
      -- local _capabilities = require("blink.cmp").get_lsp_capabilities()
      -- local _capabilities = vim.lsp.protocol.make_client_capabilities()
      local _capabilities = require('cmp_nvim_lsp').default_capabilities()

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
        "vtsls",
        "yamlls",
        "biome",
        "marksman",
        "rust_analyzer"
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
            capabilities = _capabilities,
            handlers = _handlers,
          })
        end,
        ["cairo_ls"] = function()
          lsp.cairo_ls.setup({
            capabilities = _capabilities,
            handlers = _handlers,
            filetypes = { "cairo" },
            cmd = { 'scarb', 'cairo-language-server' },
            root_dir = require("lspconfig").util.root_pattern('.git'),
          })
        end,
        ["cssls"] = function()
          lsp.cssls.setup({
            capabilities = _capabilities,
            handlers = _handlers,
            filetypes = { "css", "scss", "less" },
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
            capabilities = _capabilities,
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
            capabilities = _capabilities,
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
            capabilities = _capabilities,
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
            capabilities = _capabilities,
            handlers = _handlers,
            filetypes = { "lua" },
            on_init = function(client)
              local path = client.workspace_folders[1].name
              if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                return
              end

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              })
            end,
            settings = {
              Lua = {}
            }
            -- settings = {
            --   Lua = {
            --     workspace = { checkThirdParty = false },
            --     telemetry = { enable = false },
            --     diagnostic = {
            --       globals = { "vim" },
            --       disable = { "missing-fields", "incomplete-signature-doc" },
            --     }
            --   },
            -- },
          })
        end,
        ["vtsls"] = function()
          require("lspconfig").vtsls.setup({
            capabilities = _capabilities,
            handlers = _handlers,
            init_options = {
              preferences = {
                importModuleSpecifierPreference = "non-relative",
              },
            },
          })
        end,
        ["rust_analyzer"] = function()
          lsp.rust_analyzer.setup({
            filetypes = { "rust" },
            capabilities = _capabilities,
            handlers = _handlers,
          })
        end,
        ["biome"] = function()
          lsp.biome.setup({
            capabilities = _capabilities,
            handlers = _handlers,
          })
        end,
        ["marksman"] = function()
          lsp.marksman.setup({
            capabilities = _capabilities,
            handlers = _handlers,
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
