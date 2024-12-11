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
vim.api.nvim_create_autocmd("BufEnter", { command = [[setlocal formatoptions-=cro]] })

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

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
      and require("ts_context_commentstring.internal").calculate_commentstring()
      or get_option(filetype, option)
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = {
      spacing = 5,
      severinity = {
        min = vim.diagnostic.severity.WARN
      }
    },
    update_in_insert = true,
  }
)

-- Automatically load session
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
  callback = function()
    if vim.fn.getcwd() ~= vim.env.HOME then
      require("persistence").load()
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = vim.api.nvim_create_augroup(
    'cmdheight_1_on_cmdlineenter',
    { clear = true }
  ),
  desc = 'Don\'t hide the status line when typing a command',
  command = ':set cmdheight=1',
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = vim.api.nvim_create_augroup(
    'cmdheight_0_on_cmdlineleave',
    { clear = true }
  ),
  desc = 'Hide cmdline when not typing a command',
  command = ':set cmdheight=0',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup(
    'hide_message_after_write',
    { clear = true }
  ),
  desc = 'Get rid of message after writing a file',
  pattern = { '*' },
  command = 'redrawstatus',
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
