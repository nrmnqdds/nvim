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

-- local get_option = vim.filetype.get_option
--
-- vim.filetype.get_option = function(filetype, option)
--   return option == "commentstring"
--       and require("ts_context_commentstring.internal").calculate_commentstring()
--       or get_option(filetype, option)
-- end

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
    float = { border = "rounded" },
    update_in_insert = true,
  }
)

-- change line number color to diagnostic
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',

    },
  },
})

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

-- rapatkan statusline to the bottom
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

-- lsp attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { silent = true, buffer = ev.buf }

    --- toggle diagnostics
    vim.g.diagnostics_visible = true

    -- local function toggle_diagnostics()
    --   if vim.g.diagnostics_visible then
    --     vim.g.diagnostics_visible = false
    --     vim.diagnostic.enable(false)
    --   else
    --     vim.g.diagnostics_visible = true
    --     vim.diagnostic.enable()
    --   end
    -- end

    vim.keymap.set(
      "n",
      "gw",
      function()
        -- Store the current position for later use with definition
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win = vim.api.nvim_get_current_win()
        local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

        -- Find another window if it exists
        local target_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if win ~= current_win then
            target_win = win
            break
          end
        end

        if not target_win then
          -- If no other window exists, create one
          vim.cmd('vsplit')
          -- vim.cmd.split({ mods = { vertical = true } })
          target_win = vim.api.nvim_get_current_win()
        else
          -- Switch to the existing window
          vim.api.nvim_set_current_win(target_win)
        end

        -- Switch back to original window temporarily
        vim.api.nvim_set_current_win(current_win)

        -- Get the definition location
        local params = vim.lsp.util.make_position_params()
        vim.lsp.buf_request(current_buf, 'textDocument/definition', params, function(_, result)
          if result and result[1] then
            -- Switch to target window and jump to definition
            vim.api.nvim_set_current_win(target_win)
            vim.lsp.util.jump_to_location(result[1], "utf-8")
          end
        end)
      end,
      vim.tbl_extend("force", opts, { desc = "✨lsp go to definition in other window" })
    )


    vim.keymap.set("n", "<leader>la",
      function()
        require("tiny-code-action").code_action()
      end,
      opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, opts)

    -- telescope
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts) -- vim.lsp.buf.implementation()
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)      -- vim.lsp.buf.references()

    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ float = { border = "rounded" } }) end, opts)

    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end, opts)

    vim.keymap.set("n", "<leader>ld", function()
      vim.diagnostic.open_float({ scope = "line" })
    end, opts)

    -- vim.keymap.set(
    --   "n",
    --   "<leader>l",
    --   function()
    --     toggle_diagnostics()
    --   end,
    --   opts)
  end,
})

-- Set DiagnosticUnnecessary to gray
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#575e89" })

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
