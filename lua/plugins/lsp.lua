return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      -- Autocompletion
      {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
          -- Snippet Engine & its associated nvim-cmp source
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",

          -- Adds LSP completion capabilities
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",

          -- Adds a number of user-friendly snippets
          "rafamadriz/friendly-snippets",

          -- Adds vscode-like pictograms
          "onsails/lspkind.nvim",
        },
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
      {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "neovim/nvim-lspconfig",
      },

      {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
    },
    config = function()
      local lsp = require('lspconfig')
      local builtin = require('telescope.builtin')
      -- local navic = require('nvim-navic')

      -- this is the function that loads the extra snippets to luasnip
      -- from rafamadriz/friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local function keymap_on_attach(_, bufnr)
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

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "✨lsp hover for docs" }))

        vim.keymap.set("n", "<leader>ld", function()
          vim.diagnostic.open_float({ scope = "line" })
        end, vim.tbl_extend("force", bufopts, { desc = "✨lsp show diagnostics" }))

        vim.keymap.set("n", "]d", function()
          vim.diagnostic.goto_next()
        end, vim.tbl_extend("force", bufopts, { desc = "✨lsp go to next diagnostic" }))

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.goto_prev()
        end, vim.tbl_extend("force", bufopts, { desc = "✨lsp go to previous diagnostic" }))

        -- vim.keymap.set(
        --   "n",
        --   "gd",
        --   function()
        --     vim.lsp.buf.definition({ reuse_win = false })
        --   end,
        --   vim.tbl_extend("force", bufopts, { desc = "✨lsp go to definition" })
        -- )
        vim.keymap.set(
          "n",
          "gw",
          function()
            -- Store the current position for later use with definition
            local current_buf = vim.api.nvim_get_current_buf()
            local current_win = vim.api.nvim_get_current_win()
            local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

            -- Find another window if it exists
            local target_win = nil
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if win ~= current_win then
                target_win = win
                break
              end
            end

            if not target_win then
              -- If no other window exists, create one
              vim.cmd('vsplit')
              -- vim.cmd.split({ mods = { vertical = true } })
              target_win = vim.api.nvim_get_current_win()
            else
              -- Switch to the existing window
              vim.api.nvim_set_current_win(target_win)
            end

            -- Switch back to original window temporarily
            vim.api.nvim_set_current_win(current_win)

            -- Get the definition location
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(current_buf, 'textDocument/definition', params, function(_, result)
              if result and result[1] then
                -- Switch to target window and jump to definition
                vim.api.nvim_set_current_win(target_win)
                vim.lsp.util.jump_to_location(result[1], "utf-8")
              end
            end)
          end,
          vim.tbl_extend("force", bufopts, { desc = "✨lsp go to definition in other window" })
        )

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
          "gi",
          function()
            -- vim.lsp.buf.implementation()
            builtin.lsp_implementations()
          end,
          vim.tbl_extend("force", bufopts, { desc = "✨lsp go to implementation" })
        )

        vim.keymap.set("n", "<leader>lr", function()
          vim.lsp.buf.rename()
          vim.cmd("silent! wa")
        end, vim.tbl_extend("force", bufopts, { desc = "✨lsp rename" }))

        vim.keymap.set(
          "n",
          "gr",
          function()
            -- vim.lsp.buf.references()
            builtin.lsp_references()
          end,
          vim.tbl_extend("force", bufopts, { desc = "✨lsp go to references", nowait = true })
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
          "<leader>la",
          -- function() vim.lsp.buf.code_action() end,
          function()
            require("tiny-code-action").code_action()
          end,
          vim.tbl_extend("force", bufopts, { desc = "✨lsp code action" })
        )
      end

      local function on_attach(client, bufnr)
        -- navic.attach(client, bufnr)
        keymap_on_attach(client, bufnr)
      end

      -- -- Use builtin LSP hover handler with rounded border
      -- -- See: https://github.com/neovim/nvim-lspconfig/issues/3036#issuecomment-2315035246
      local _handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      -- to learn how to use mason.nvim with lsp-zero
      -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      require('mason').setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require('mason-lspconfig').setup({
        ensure_installed = {
          -- 'tsserver', deprecated
          'ts_ls',
          'astro',
          'biome',
          'tailwindcss',
          'volar',
          'yamlls',
          'lua_ls',
          'gopls',
          'dockerls',
          'prismals',
          'marksman',
          'html',
          'templ',
          -- 'sqlls'
        },
      })

      -- If you are using mason.nvim, you can get the ts_plugin_path like this
      local mason_registry = require('mason-registry')
      local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()

      lsp.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_language_server_path,
              languages = { 'vue' },
            },
          },
        },
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
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        },
      })
      lsp.astro.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      -- lsp.dartls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   handlers = _handlers,
      -- })
      lsp.biome.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.volar.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
        handlers = _handlers,
      })
      lsp.dockerls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.templ.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.prismals.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.marksman.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = _handlers,
      })
      lsp.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              globals = { "vim" },
              disable = { "missing-fields", "incomplete-signature-doc" },
            }
          }
        },
        handlers = _handlers,
      })
      lsp.yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        handlers = _handlers,
        -- on_attach = function(client, buffer)
        --   if client.name == "yamlls" then
        --     client.resolved_capabilities.document_formatting = true
        --   end
        -- end,

        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.*",
              ["https://json.schemastore.org/catalog-info.json"] = ".backstage/*.yaml",
              ["https://raw.githubusercontent.com/iterative/dvcyaml-schema/master/schema.json"] = "**/dvc.yaml",
              ["https://json.schemastore.org/swagger-2.0.json"] = "**/swagger.yaml",
              -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml"] = "/*"
            },
          },
          format = {
            enable = true,
            singleQuote = false,
            bracketSpacing = true,
          },
          validate = true,
          completion = true,
        },
      })

      -- configure Swift serve here since it is not installed via Mason
      lsp.sourcekit.setup({
        -- capabilities = capabilities,
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      })
      -- lsp.sqlls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   handlers = _handlers,
      --   filetypes = { 'sql' },
      --   root_dir = function(_)
      --     return vim.loop.cwd()
      --   end,
      -- })

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

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      -- local lspkind = require("lspkind")

      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        -- enabled = false,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          -- ["<CR>"] = cmp.mapping.confirm({
          --   behavior = cmp.ConfirmBehavior.Replace,
          --   select = true,
          -- }),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "calc" },
          { name = "emoji" },
          { name = "treesitter" },
        },
        -- formatting = {
        --   fields = { "kind", "abbr", "menu" },
        --   format = function(entry, vim_item)
        --     local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
        --     kind.kind = " " .. (strings[1] or "") .. " "
        --     kind.menu = "    (" .. (strings[2] or "") .. ")"
        --
        --     return kind
        --   end,
        -- },
        formatting = {
          -- fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local lspkind_ok, lspkind = pcall(require, "lspkind")
            if not lspkind_ok then
              -- From kind_icons array
              vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item)
              -- Source
              vim_item.menu = ({
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                luasnip = "[LuaSnip]",
                buffer = "[Buffer]",
                latex_symbols = "[LaTeX]",
              })[entry.source.name]
              return vim_item
            else
              -- From lspkind
              -- local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
              -- local strings = vim.split(kind.kind, "%s")
              -- kind.kind = " " .. (strings[1] or "") .. " "
              -- kind.menu = "    [" .. (strings[2] or "") .. "]"
              --
              -- return kind
              return lspkind.cmp_format()(entry, vim_item)
            end
          end,
        },
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
