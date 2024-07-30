local cinnamon = require("cinnamon")

cinnamon.setup()

-- Centered scrolling:
vim.keymap.set("n", "<C-u>", function() cinnamon.scroll("<C-U>zz") end)
vim.keymap.set("n", "<C-d>", function() cinnamon.scroll("<C-D>zz") end)

-- LSP:
vim.keymap.set("n", "gd", function() cinnamon.scroll(vim.lsp.buf.definition) end)
vim.keymap.set("n", "gD", function() cinnamon.scroll(vim.lsp.buf.declaration) end)

-- Basic vim motions:
-- vim.keymap.set("n", "H", function() cinnamon.scroll("^") end)
-- vim.keymap.set("n", "L", function() cinnamon.scroll("g_") end)
vim.keymap.set("n", "w", function() cinnamon.scroll("w") end)
vim.keymap.set("n", "b", function() cinnamon.scroll("b") end)
vim.keymap.set("n", "e", function() cinnamon.scroll("e") end)
vim.keymap.set("n", "j", function() cinnamon.scroll("j") end)
vim.keymap.set("n", "k", function() cinnamon.scroll("k") end)
-- vim.keymap.set({ "n", "v", "x" }, "gg", function() cinnamon.scroll("gg") end)
-- vim.keymap.set({ "n", "v", "x" }, "G", function() cinnamon.scroll("G") end)
