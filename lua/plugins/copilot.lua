return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 50,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    }
  },

  -- {
  --   'milanglacier/minuet-ai.nvim',
  --   config = function()
  --     require('minuet').setup {
  --       virtualtext = {
  --         auto_trigger_ft = { '*' },
  --         keymap = {
  --           -- accept whole completion
  --           accept = '<tab>',
  --           -- accept one line
  --           accept_line = '<tab>',
  --         },
  --       },
  --
  --       provider = 'openai_fim_compatible',
  --       n_completions = 1, -- recommend for local model for resource saving
  --       -- I recommend beginning with a small context window size and incrementally
  --       -- expanding it, depending on your local computing power. A context window
  --       -- of 512, serves as an good starting point to estimate your computing
  --       -- power. Once you have a reliable estimate of your local computing power,
  --       -- you should adjust the context window to a larger value.
  --       context_window = 2000,
  --       provider_options = {
  --         openai_fim_compatible = {
  --           api_key = 'TERM',
  --           name = 'Ollama',
  --           end_point = 'http://localhost:11434/v1/completions',
  --           model = 'qwen2.5-coder:1.5b',
  --           optional = {
  --             max_tokens = 56,
  --             top_p = 0.9,
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- provider = "ollama",
      -- vendors = {
      --   ollama = {
      --     __inherited_from = "openai",
      --     api_key_name = "",
      --     endpoint = "http://127.0.0.1:11434/v1",
      --     model = "deepseek-r1:1.5b",
      --   },
      -- },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },


}
