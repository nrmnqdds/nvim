local builtin = require('telescope.builtin')
local action = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope = require("telescope")

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>fs', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<C-e>', function()
  builtin.buffers({
    initial_mode = "normal",
  }, {
    sort_lastused = true,
    sort_mru = true,
  });
end)

local m = {}

m.my_buffer = function(opts)
  opts = opts or {}
  opts.attach_mappings = function(prompt_bufnr, map)
    local delete_buf = function()
      local selection = action_state.get_selected_entry()
      action.close(prompt_bufnr)
      vim.api.nvim_buf_delete(selection.bufnr, { force = true })
    end
    map('i', '<c-u>', delete_buf)
    return true
  end
  opts.previewer = false
  -- define more opts here
  -- opts.show_all_buffers = true
  -- opts.sort_lastused = true
  -- opts.shorten_path = false
  require('telescope.builtin').buffers(require('telescope.themes').get_dropdown(opts))
end

-- telescope.load_extension("fzf")
telescope.load_extension("ui-select")
-- telescope.load_extension("refactoring")
telescope.load_extension("zf-native")
telescope.load_extension("dap")
-- telescope.load_extension("frecency")
-- telescope.load_extension("notify")
-- telescope.load_extension("package_info")
