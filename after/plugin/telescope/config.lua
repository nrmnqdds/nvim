local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope = require("telescope")

telescope.load_extension("ui-select")
telescope.load_extension("zf-native")
telescope.load_extension("dap")
telescope.load_extension("media_files")

telescope.setup({
  defaults = {
    layout_config = {
      horizontal = {
        preview_cutoff = 0
      }
    }
  }
})

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- vim.keymap.set('n', '<leader>pf', function()
--   vim.cmd("Telescope frecency workspace=CWD")
-- end)
vim.keymap.set('n', '<leader>po', function()
  vim.cmd("Telescope frecency")
end)
vim.keymap.set('n', '<C-p>fs', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<C-e>', function()
  builtin.buffers({
    initial_mode = "normal",
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        end)
      end

      map('n', '<c-d>', delete_buf)

      return true
    end
  }, {
    sort_lastused = true,
    sort_mru = true,
    theme = "dropdown"
  })
end)
