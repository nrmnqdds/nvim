return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    dev_log = {
      -- toggle it when you run without DAP
      enabled = false,
      open_cmd = "tabedit",
    },
    config = function()
      -- alternatively you can override the default configs
      require("flutter-tools").setup({
        ui = {
          -- the border type to use for all floating windows, the same options/formats
          -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
          border = "rounded",
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = false,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = false,
          }
        },
        root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
        widget_guides = {
          enabled = true,
        },
        -- closing_tags = {
        --   highlight = "ErrorMsg", -- highlight for the closing tag
        --   prefix = ">",           -- character to use for close tag e.g. > Widget
        --   priority = 10,          -- priority of virtual text in current line
        --   -- consider to configure this when there is a possibility of multiple virtual text items in one line
        --   -- see `priority` option in |:help nvim_buf_set_extmark| for more info
        --   enabled = true -- set to false to disable
        -- },
        dev_log = {
          enabled = true,
          filter = nil, -- optional callback to filter the log
          -- takes a log_line as string argument; returns a boolean or nil;
          -- the log_line is only added to the output if the function returns true
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = "15split",  -- command to use to open the log buffer
          focus_on_open = true,  -- focus on the newly opened log window
        },
        dev_tools = {
          autostart = false,         -- autostart devtools server if not detected
          auto_open_browser = false, -- Automatically opens devtools in the browser
        },
        outline = {
          open_cmd = "30vnew", -- command to use to open the outline buffer
          auto_open = false    -- if true this will open the outline automatically when it is first populated
        },
        lsp = {
          color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = false, -- highlight the background
            background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
          },
          -- on_attach = my_custom_on_attach,
          on_attach = function(_, bufnr)
            local builtin = require('telescope.builtin')
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
            vim.keymap.set("n", "K", vim.lsp.buf.hover,
              vim.tbl_extend("force", bufopts, { desc = "✨lsp hover for docs" }))

            vim.keymap.set("n", "<leader>ld", function()
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
              "<leader>la",
              -- function() vim.lsp.buf.code_action() end,
              function()
                require("tiny-code-action").code_action()
              end,
              vim.tbl_extend("force", bufopts, { desc = "✨lsp code action" })
            )
          end,
          -- capabilities = my_custom_capabilities, -- e.g. lsp_status capabilities
          --- OR you can specify a function to deactivate or change or control how the config is created
          capabilities = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            return vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
          end,
          -- see the link below for details on each option:
          -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true,      -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          }
        }
      })
    end,
  },

  -- for dart syntax hightling
  -- {
  --   "dart-lang/dart-vim-plugin"
  -- },

  'reisub0/hot-reload.vim',

}
