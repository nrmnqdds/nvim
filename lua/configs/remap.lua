local map = vim.keymap.set

-- open netrw file explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer", noremap = true, silent = true })

-- move lines
map("v", "<S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", noremap = true, silent = true })
map("v", "<S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", noremap = true, silent = true })

-- Fast saving
map("n", "<Leader>w", function()
  -- vim.lsp.buf.format()
  vim.cmd("silent! write!")
end, { desc = "Fast save", noremap = true, silent = true })

-- Fast quitting current buffer
map("n", "<Leader>qq", ":q<CR>", { desc = "Fast quit", noremap = true, silent = true })

-- Fast quitting all
map("n", "<Leader>qa", ":qa<CR>", { desc = "Fast quit all", noremap = true, silent = true })

-- scroll without moving the cursor
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up without moving the cursor", noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down without moving the cursor", noremap = true, silent = true })

-- fast w/b
map("n", "<S-w>", "3w", { desc = "3w", noremap = true, silent = true })
map("n", "<S-b>", "3b", { desc = "3b", noremap = true, silent = true })

-- enter normal mode in terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter normal mode in terminal", noremap = true, silent = true })

-- paste without copying the text
map({ "x", "v" }, "<leader>p", [["_dP]], { desc = "Paste without copying the text", noremap = true, silent = true })

-- copy to system clipboard
map({ "x", "v", "n" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard", noremap = true, silent = true })

map({ "i", "v", "x" }, "<C-c>", "<Esc>", { desc = "Exit insert mode", noremap = true, silent = true })

-- format file
map("n", "<leader>f", function()
  -- vim.lsp.buf.format{ timeout = 2000 }
  require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 2000 })
end, { desc = "Format file with Conform", noremap = true, silent = true })

-- trouble plugin
-- map("n", "<leader>xx", function() require("trouble").toggle() end)
-- map("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
-- map("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
-- map("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
-- map("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
-- map("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- select all
map("n", "<C-a>", "gg<S-v>G<C-o>", { desc = "Select all", noremap = true, silent = true })

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", { desc = "Move to start of line", noremap = true, silent = true })
map({ "n", "x", "o" }, "L", "g_", { desc = "Move to end of line", noremap = true, silent = true })

-- Enter new line below in insert mode
map("n", "<C-Enter>", "o", { desc = "Enter new line below in normal mode", noremap = true, silent = true })
map("n", "<C-S-Enter>", "O", { desc = "Enter new line below in normal mode", noremap = true, silent = true })

-- Enter new line above in insert mode
map("i", "<C-Enter>", "<Esc>o", { desc = "Enter new line below in insert mode", noremap = true, silent = true })
map("i", "<C-S-Enter>", "<Esc>O", { desc = "Enter new line above in insert mode", noremap = true, silent = true })

-- search and replace
map({ "n", "v" }, "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace", noremap = true, silent = true })

-- Split line with X
map("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>",
  { desc = "Split line", noremap = true, silent = true })

-- Navigate buffers
map("n", "<C-j>", ":bnext<CR>", { desc = "Navigate buffers", noremap = true, silent = true })
map("n", "<C-k>", ":bprevious<CR>", { desc = "Navigate buffers", noremap = true, silent = true })
map("n", "<leader>dd", ":bd<CR>", { desc = "Close current buffer", noremap = true, silent = true })
map("n", "<leader>da", ":%bd|e#|bd#<CR>", { desc = "Close all buffer", noremap = true, silent = true })

-- Close highlighted search
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Close highlighted search", noremap = true, silent = true })

-- Go to previous opened buffer
map("n", "<C-b>", "<C-^>zz", { desc = "Go to previous opened buffer", noremap = true, silent = true })

-- Switch window
map("n", "<Tab>", "<C-w>w", { desc = "Switch window", noremap = true, silent = true })

-- Moves cursor in insert mode
map("i", "<C-l>", "<Right>", { desc = "Move cursor right in insert mode", noremap = true, silent = true })
map("i", "<C-h>", "<Left>", { desc = "Move cursor left in insert mode", noremap = true, silent = true })

-- Resize window height
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window height", noremap = true, silent = true })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window height", noremap = true, silent = true })

-- Resize window width
map("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Resize window width", noremap = true, silent = true })
map("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Resize window width", noremap = true, silent = true })

map("n", ";", ":", { desc = "Enter command mode", noremap = true, silent = true })

map("n", "<leader>cc", function() require("screenkey").toggle() end,
  { desc = "Toggle ScreenKey", noremap = true, silent = true })

map("n", "@", "@a", { desc = "Play macros", noremap = true, silent = true })

map('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab", noremap = true, silent = true })

map("n", "<C-t>", function()
  require("cloak").toggle()
end, { noremap = true, silent = true })
