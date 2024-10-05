local hlchunk = require("hlchunk")

hlchunk.setup({
  chunk = {
    enable = true,
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
})
