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
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup()
    end
  },

  'dstein64/nvim-scrollview',

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
