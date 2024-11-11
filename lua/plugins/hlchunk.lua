return {
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = false,
        style = {
          { fg = "#00ffff" },
          { fg = "#f35336" },
        },
        chars = {
          right_arrow = "─",
        },
        delay = 100,
        duration = 100,
      },
      indent = {
        enable = true
        -- ...
      }
    }
  },

}
