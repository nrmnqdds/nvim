return {
  "isak102/ghostty.nvim",
  config = function()
    require("ghostty").setup({
      -- The pattern to match the file name. If the file name matches the
      -- pattern, ghostty.nvim will run on save in that buffer.
      file_pattern = "*/ghostty/config",
      -- The ghostty executable to run.
      ghostty_cmd = "ghostty",
      -- The timeout in milliseconds for the check command.
      -- If the command takes longer than this it will be killed.
      check_timeout = 1000,
    })
  end,
}
