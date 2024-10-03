local map = vim.keymap.set
local opt = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- open netrw file explorer
map("n", "<leader>pv", vim.cmd.Ex, opt)

-- move lines
map("v", "J", ":m '>+1<CR>gv=gv", opt)
map("v", "K", ":m '<-2<CR>gv=gv", opt)

-- Fast format and saving
map("n", "<Leader>w", function()
  -- vim.lsp.buf.format()
  vim.cmd("silent! write!")
end, opt)

-- Fast quitting
map("n", "<Leader>qq", ":q!<CR>", opt)

-- Fast quitting all
map("n", "<Leader>qa", ":qa!<CR>", opt)

-- scroll without moving the cursor
-- map("n", "<C-u>", "<C-u>zz", opt)
-- map("n", "<C-d>", "<C-d>zz", opt)

-- enter normal mode in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- paste without copying the text
map({ "x", "v" }, "p", [["_dP]], opt)

-- copy to system clipboard
map({ "x", "v", "n" }, "<leader>y", [["+y]], opt)

map({ "i", "v", "x" }, "<C-c>", "<Esc>", opt)

-- format file
map("n", "<leader>f", function()
  -- vim.lsp.buf.format{ timeout = 2000 }
  require("conform").format()
end, opt)

-- trouble plugin
map("n", "<leader>xx", function() require("trouble").toggle() end, opt)
map("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, opt)
map("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, opt)
map("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, opt)
map("n", "<leader>xl", function() require("trouble").toggle("loclist") end, opt)
map("n", "gR", function() require("trouble").toggle("lsp_references") end, opt)

-- select all
map("n", "<C-a>", "gg<S-v>G", opt)

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", opt)
map({ "n", "x", "o" }, "L", "g_", opt)

-- Enter new line below in insert mode
map("n", "<C-Enter>", "o", opt)
map("n", "<C-S-Enter>", "O", opt)

-- Enter new line above in insert mode
map("i", "<C-Enter>", "<Esc>o", opt)
map("i", "<C-S-Enter>", "<Esc>O", opt)

-- search and replace
map({ "n", "v" }, "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opt)

-- search current buffer
map("n", "<C-f>", ":Telescope current_buffer_fuzzy_find<CR>", opt)

-- live grep
map("n", "<C-l>", ":Telescope live_grep<CR>", opt)

-- Split line with X
map("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", opt)

-- Navigate buffers
map("n", "<C-j>", ":bnext<CR>", opt)
map("n", "<C-k>", ":bprevious<CR>", opt)
map("n", "<leader>d", ":bd<CR>", opt)

-- Close highlighted search
map("n", "<Esc>", ":nohlsearch<CR>", opt)

-- Go to previous opened buffer
map("n", "<C-b>", "<C-^>zz", opt)

-- Switch window
map("n", "<Tab>", "<C-w>w", opt)

-- Moves cursor in insert mode
map("i", "<C-l>", "<Right>", opt)
map("i", "<C-h>", "<Left>", opt)

-- Resize window height
map("n", "<C-Up>", ":resize -2<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)

-- Resize window width
map("n", "<C-Left>", ":vertical resize +2<CR>", opt)
map("n", "<C-Right>", ":vertical resize -2<CR>", opt)

map("n", ";", ":", opt)

map({ "v", "x" }, "q", "<C-c>", opt)

map("n", "<leader>cc", function() require("screenkey").toggle() end)

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- auto close brackets
-- vim.api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })


-- Automatically opens vim apm when vim starts
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- Toggle vim apm monitor
--     require("vim-apm"):toggle_monitor()
--   end,
-- })

--- autocmd to show diagnostics on CursorHold
-- vim.api.nvim_create_autocmd("CursorHold", {
--   buffer = bufnr,
--   desc = "✨lsp show diagnostics on CursorHold",
--   callback = function()
--     local hover_opts = {
--       focusable = false,
--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--       border = "rounded",
--       source = "always",
--       prefix = " ",
--     }
--     vim.diagnostic.open_float(nil, hover_opts)
--   end,
-- })
