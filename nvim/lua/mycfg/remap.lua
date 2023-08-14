vim.g.mapleader = " "

-- Unset keybindings
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("i", "<c-y>", "<nop>")

-- Undo mapping
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- File management
vim.keymap.set("n", "<leader>pd", vim.cmd.NvimTreeToggle)

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Paste over without affecting buffer.
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Clipboard management
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


-- Format
vim.keymap.set("n", "<leader>ff", function()
  vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
end)
vim.keymap.set("n", "<leader>ft", "gg=G")

-- Find and replace all occurrences
vim.keymap.set("n", "<leader>rr", ":%s/<c-r><c-w>/<c-r><c-w>/gI<Left><Left><Left>")
vim.keymap.set("v", "<leader>rr", "<Esc>:%s/<c-r><c-w>/<c-r><c-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>rt", vim.lsp.buf.rename)
vim.keymap.set("v", "<leader>rt", vim.lsp.buf.rename)

-- LSP
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration)
vim.keymap.set("n", "<leader>lD", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references)
vim.keymap.set("i", "<c-h>", vim.lsp.buf.hover)
vim.keymap.set("n", "<c-h>", vim.lsp.buf.hover)

-- Errors
vim.keymap.set("n", "<leader>ee", "<cmd>TroubleToggle<cr>", { noremap = true })
vim.keymap.set("n", "<leader>eq", "<cmd>TroubleToggle quickfix<cr>", { noremap = true })

-- Git
vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis<cr>')
vim.keymap.set('n', '<leader>gf', ':DiffviewFileHistory %<cr>')
vim.keymap.set('n', '<leader>gb', ':Dif,fviewFileHistory<cr>')
vim.keymap.set('n', '<leader>gc', ':DiffviewClose<cr>')
vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>')
vim.keymap.set('n', '<leader>ga', ':Git add <c-r>%<cr>')

-- Better scrolling
vim.keymap.set('n', '<c-j>', '<c-d>zz')
vim.keymap.set('n', '<c-k>', '<c-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
