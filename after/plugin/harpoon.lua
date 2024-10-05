local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
  local finder = function()
    local paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(paths, item.value)
    end

    return require("telescope.finders").new_table({
      results = paths,
    })
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = finder(),
    previewer = conf.file_previewer({}),
    sorter = require("telescope.config").values.generic_sorter({}),
    layout_config = {
      -- height = 0.4,
      -- width = 0.5,
      prompt_position = "bottom",
      preview_cutoff = 120,
    },
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<C-d>", function()
        local state = require("telescope.actions.state")
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)

        table.remove(harpoon_files.items, selected_entry.index)
        current_picker:refresh(finder())
      end)
      return true
    end,
  }):find()
end
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers").new({}, {
--     initial_mode = "normal",
--     prompt_title = "Harpoon",
--     finder = require("telescope.finders").new_table({
--       results = file_paths,
--     }),
--     previewer = conf.file_previewer({}),
--     sorter = conf.generic_sorter({}),
--   }):find()
-- end

vim.keymap.set("n", "<leader>hl", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

-- vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hd", function() harpoon:list():remove() end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-j>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():next() end)
