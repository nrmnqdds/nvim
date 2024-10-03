local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local trouble = require("trouble.sources.telescope")
local telescope = require("telescope")
local icons = require("configs.icons")

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("dap")
telescope.load_extension("media_files")
telescope.load_extension("frecency")
telescope.load_extension("notify")

local function document_symbols_for_selected(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if entry == nil then
    print("No file selected")
    return
  end

  actions.close(prompt_bufnr)

  vim.schedule(function()
    local bufnr = vim.fn.bufadd(entry.path)
    vim.fn.bufload(bufnr)

    local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

    vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result, _, _)
      if err then
        print("Error getting document symbols: " .. vim.inspect(err))
        return
      end

      if not result or vim.tbl_isempty(result) then
        print("No symbols found")
        return
      end

      local function flatten_symbols(symbols, parent_name)
        local flattened = {}
        for _, symbol in ipairs(symbols) do
          local name = symbol.name
          if parent_name then
            name = parent_name .. "." .. name
          end
          table.insert(flattened, {
            name = name,
            kind = symbol.kind,
            range = symbol.range,
            selectionRange = symbol.selectionRange,
          })
          if symbol.children then
            local children = flatten_symbols(symbol.children, name)
            for _, child in ipairs(children) do
              table.insert(flattened, child)
            end
          end
        end
        return flattened
      end

      local flat_symbols = flatten_symbols(result)

      -- Define highlight group for symbol kind
      vim.cmd([[highlight TelescopeSymbolKind guifg=#61AFEF]])

      require("telescope.pickers").new({}, {
        prompt_title = "Document Symbols: " .. vim.fn.fnamemodify(entry.path, ":t"),
        finder = require("telescope.finders").new_table({
          results = flat_symbols,
          entry_maker = function(symbol)
            local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Other"
            return {
              value = symbol,
              display = function(_entry)
                local display_text = string.format("%-50s %s", _entry.value.name, kind)
                return display_text, { { { #entry.value.name + 1, #display_text }, "TelescopeSymbolKind" } }
              end,
              ordinal = symbol.name,
              filename = entry.path,
              lnum = symbol.selectionRange.start.line + 1,
              col = symbol.selectionRange.start.character + 1,
            }
          end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        previewer = require("telescope.config").values.qflist_previewer({}),
        attach_mappings = function(_, map)
          map("i", "<CR>", function(_prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(_prompt_bufnr)
            vim.cmd("edit " .. selection.filename)
            vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
          end)
          return true
        end,
      }):find()
    end)
  end)
end


telescope.setup({
  defaults = {
    -- layout_config = {
    --   horizontal = {
    --     preview_cutoff = 0
    --   }
    -- },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-t>"] = trouble.open,

        ["<C-s>"] = document_symbols_for_selected,
      },

      n = {
        ["<C-t>"] = trouble.open,
        ["<C-s>"] = document_symbols_for_selected,
      },


    },
    -- path_display = formattedName,
    path_display = {
      "filename_first",
    },
    previewer = false,
    prompt_prefix = " " .. icons.ui.Telescope .. " ",
    selection_caret = icons.ui.BoldArrowRight .. " ",
    file_ignore_patterns = { "node_modules", "package-lock.json" },
    initial_mode = "insert",
    select_strategy = "reset",
    sorting_strategy = "ascending",
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    layout_config = {
      prompt_position = "top",
      preview_cutoff = 120,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
    },
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
