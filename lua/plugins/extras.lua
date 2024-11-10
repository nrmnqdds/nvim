return {
  {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = {
        auto_attach = true,
      }
    }
  },
  {
    "LunarVim/breadcrumbs.nvim",
    opts = {}
  },
  {
    "j-hui/fidget.nvim",
    opts = {}
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs                        = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      auto_attach                  = true,
      attach_to_untracked          = false,
      current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    }
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup()
    end
  },

  'dstein64/nvim-scrollview',

  {
    'vyfor/cord.nvim',
    build = './build',
    event = 'VeryLazy',
    opts = {
      usercmds = true,           -- Enable user commands
      log_level = 'error',       -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
      timer = {
        interval = 1500,         -- Interval between presence updates in milliseconds (min 500)
        reset_on_idle = false,   -- Reset start timestamp on idle
        reset_on_change = false, -- Reset start timestamp on presence change
      },
      editor = {
        image = 'https://styles.redditmedia.com/t5_30kix/styles/communityIcon_n2hvyn96zwk81.png', -- Image ID or URL in case a custom client id is provided. Default: nil
        client = 'neovim',                                                                        -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
        tooltip = 'The Superior Text Editor',                                                     -- Text to display when hovering over the editor's image
      },
      display = {
        show_time = true,             -- Display start timestamp
        show_repository = true,       -- Display 'View repository' button linked to repository url, if any
        show_cursor_position = false, -- Display line and column number of cursor's position
        swap_fields = false,          -- If enabled, workspace is displayed first
        swap_icons = false,           -- If enabled, editor is displayed on the main image
        workspace_blacklist = {},     -- List of workspace names to hide
      },
      lsp = {
        show_problem_count = false, -- Display number of diagnostics problems
        severity = 1,               -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
        scope = 'workspace',        -- buffer or workspace
      },
      idle = {
        enable = true, -- Enable idle status
        show_status = true, -- Display idle status, disable to hide the rich presence on idle
        timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
        disable_on_focus = false, -- Do not display idle status when neovim is focused
        text = 'Idle', -- Text to display when idle
        tooltip = '💤', -- Text to display when hovering over the idle image
      },
      text = {
        viewing = 'Viewing {}',                    -- Text to display when viewing a readonly file
        editing = 'Editing {}',                    -- Text to display when editing a file
        file_browser = 'Browsing files in {}',     -- Text to display when browsing files (Empty string to disable)
        plugin_manager = 'Managing plugins in {}', -- Text to display when managing plugins (Empty string to disable)
        lsp_manager = 'Configuring LSP in {}',     -- Text to display when managing LSP servers (Empty string to disable)
        vcs = 'Committing changes in {}',          -- Text to display when using Git or Git-related plugin (Empty string to disable)
        workspace = 'In {}',                       -- Text to display when in a workspace (Empty string to disable)
      },
      buttons = {
        {
          label = 'View Repository', -- Text displayed on the button
          url = 'git',               -- URL where the button leads to ('git' = automatically fetch Git repository URL)
        },
        -- {
        --   label = 'View Plugin',
        --   url = 'https://github.com/vyfor/cord.nvim',
        -- }
      },
      assets = nil, -- Custom file icons, see the wiki*
      -- assets = {
      --   lazy = {                                 -- Vim filetype or file name or file extension = table or string
      --     name = 'Lazy',                         -- Optional override for the icon name, redundant for language types
      --     icon = 'https://example.com/lazy.png', -- Rich Presence asset name or URL
      --     tooltip = 'lazy.nvim',                 -- Text to display when hovering over the icon
      --     type = 2,                              -- 0 = language, 1 = file browser, 2 = plugin manager, 3 = lsp manager, 4 = vcs; defaults to language
      --   },
      --   ['Cargo.toml'] = 'crates',
      -- },
    },
  },

  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
    config = function()
      require("screenkey").setup()
    end,
  },

  {
    "laytan/cloak.nvim",
    opts = {
      enabled = true,
      cloak_character = "*",
      -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
      highlight_group = "Comment",
      patterns = {
        {
          -- Match any file starting with ".env".
          -- This can be a table to match multiple file patterns.
          file_pattern = {
            ".env*",
            "wrangler.toml",
            ".dev.vars",
          },
          -- Match an equals sign and any character after it.
          -- This can also be a table of patterns to cloak,
          -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
          cloak_pattern = "=.+"
        },
      },
    }
  },

  {
    "mg979/vim-visual-multi",
    branch = 'master'
  },
  "mfussenegger/nvim-dap",

}
