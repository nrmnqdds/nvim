return {
  -- {
  --   'Bekaboo/dropbar.nvim',
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim',
  --     build = 'make'
  --   }
  -- },

  {
    "j-hui/fidget.nvim",
    opts = {}
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  -- {
  --   "rmagatti/auto-session",
  --   config = function()
  --     require("auto-session").setup()
  --   end
  -- },

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

  {
    "sphamba/smear-cursor.nvim",
    opts = { -- Default  Range
      -- fire trailing
      -- cursor_color = "#ff8800",
      -- stiffness = 0.3,
      -- trailing_stiffness = 0.1,
      -- trailing_exponent = 5,
      -- hide_target_hack = true,
      -- gamma = 1,

      -- faster smear
      -- stiffness = 0.8,             -- 0.6      [0, 1]
      -- trailing_stiffness = 0.5,    -- 0.3      [0, 1]
      -- distance_stop_animating = 0.5, -- 0.1      > 0
    },
  },

  {
    'dstein64/nvim-scrollview',
    opts = {}
  },

  -- {
  --   "atiladefreitas/lazyclip",
  --   config = function()
  --     require("lazyclip").setup()
  --   end,
  --   keys = {
  --     { "<leader>cy", ":lua require('lazyclip').show_clipboard()<CR>", { desc = "Open Clipboard Manager", noremap = true, silent = true } },
  --   },
  -- },
  --
  "b0o/schemastore.nvim",

}
