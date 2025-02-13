return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        -- other configs
        on_colors = function(colors)
          colors.border = "#565f89"
          colors.bg = "#09090b"
        end
      })
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
}
