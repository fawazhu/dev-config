vim.cmd.colorscheme "catppuccin-mocha"

require("catppuccin").setup({
  integrations = {
    cmp = true,
    gitsigns = true,
    harpoon = true,
    indent_blankline = true,
    lsp_trouble = true,
    mason = true,
    nvimtree = true,
    telescope = true,
    treesitter = true
  }
})
