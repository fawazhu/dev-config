-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 25,
  },
  renderer = {
    group_empty = true,
    add_trailing = true,
    indent_markers = {
      enable = true,
      inline_arrows = false
    },
    icons = {
      show = {
        folder_arrow = false
      }
    }
  },
  filters = {
    custom = {
      '\\v^.git(ignore)@!'
    },
    git_ignored = false,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
  },
  modified = {
    enable = true
  }
})
