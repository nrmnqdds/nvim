local neoscroll = require("neoscroll")

neoscroll.setup({
  mappings = {},
  hide_cursor = false,         -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing = 'linear',           -- Default easing function
  pre_hook = function(info) if info == "cursorline" then vim.cmd("normal! zz") end end,
  post_hook = function(info) if info == "cursorline" then vim.cmd("normal! zz") end end,
})

local keymap = {
  ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 50, info = "cursorline" }) end,
  ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 50, info = "cursorline" }) end,
}
local modes = { 'n' }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func)
end
