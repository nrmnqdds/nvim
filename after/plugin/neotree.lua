require('neo-tree').setup({
  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false
    },
    filtered_items = {
      visible = true,
      show_hidden_count = true,
      hide_dotfiles = false,
      hide_gitignore = false
    }
  },
  default_component_configs = {
    git_status = {
      symbols = {
        added = "+",
        modified = "!",
        deleted = "-",
        renamed = "»",

        untracked = "?",
        ignored = "x",
        unstaged = "!",
        staged = "+",
        conflicted = "~"
      }
    }
  },
  close_if_last_window = true,
  window = {
    position = "right"
  },
})
