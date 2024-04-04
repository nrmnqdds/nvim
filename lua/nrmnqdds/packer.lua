-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }

  use {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }

  use { 'nvim-telescope/telescope.nvim', tag = '0.1.6',
  -- or                            , branch = '0.1.x',
  requires = { { 'nvim-lua/plenary.nvim' } }
}

use {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate'
}

use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  requires = {
    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    -- {'williamboman/mason.nvim'},
    -- {'williamboman/mason-lspconfig.nvim'},

    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },
  }
}

use {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
}

use {
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
}

-- Installation
use { 'L3MON4D3/LuaSnip' }
use {
  'hrsh7th/nvim-cmp',
  config = function()
    require 'cmp'.setup {
      snippet = {
        expand = function(args)
          require 'luasnip'.lsp_expand(args.body)
        end
      },

      sources = {
        { name = 'luasnip' },
        -- more sources
      },
    }
  end
}
use { 'saadparwaiz1/cmp_luasnip' }

use { "rafamadriz/friendly-snippets" }


use {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup {}
  end
}

use {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  }
}

use {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
    local ft = require('Comment.ft')

    ft.set('typescriptreact', { '//%s', '{/*%s*/}' })
  end
}

use {
  "folke/trouble.nvim",
  requires = { "nvim-tree/nvim-web-devicons" },
}

use { "nvim-lua/plenary.nvim" } -- don't forget to add this one if you don't have it yet!
use {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  requires = { { "nvim-lua/plenary.nvim" } }
}

use({
  "kylechui/nvim-surround",
  tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
  end
})

use { "lukas-reineke/indent-blankline.nvim" }

use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

use { 'yorickpeterse/nvim-pqf' }

use {
  "folke/which-key.nvim",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}

-- use { 'f-person/git-blame.nvim' }

use { 'windwp/nvim-ts-autotag' }

use {'j-hui/fidget.nvim'}

use {
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls").builtins
			opts.sources = vim.list_extend(opts.sources or {}, {
				nls.formatting.biome,

				-- or if you like to live dangerously like me:
				nls.formatting.biome.with({
					args = {
						'check',
						'--apply-unsafe',
						'--formatter-enabled=true',
						'--organize-imports-enabled=true',
						'--skip-errors',
						'$FILENAME',
					},
				}),
			})
		end,
	}

  use {"lewis6991/gitsigns.nvim"}

end)
