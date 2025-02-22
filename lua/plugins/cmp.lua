return {
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
      'L3MON4D3/LuaSnip',
    },
    config = function()
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
          -- { name = "copilot" },
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

}
