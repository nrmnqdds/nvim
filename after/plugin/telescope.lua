local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope = require("telescope")

telescope.setup({})
telescope.load_extension("ui-select")
telescope.load_extension("zf-native")
telescope.load_extension("dap")

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>fs', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<C-e>', function()
  builtin.buffers({
    initial_mode = "normal",
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
      end

      map('n', '<c-d>', delete_buf)

      -- builtin.buffers(require('telescope.themes').get_dropdown())
      return true
    end
  }, {
    sort_lastused = true,
    sort_mru = true,
    theme = "dropdown"
  })
end)
