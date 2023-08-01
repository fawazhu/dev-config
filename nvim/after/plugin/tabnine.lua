require('tabnine').setup({
  disable_auto_comment = true,
  accept_keymap = "<c-q>",
  dismiss_keymap = "<c-1>",
  debounce_ms = 500,
  suggestion_color = { gui = "#808080", cterm = 244 },
  exclude_filetypes = { "TelescopePrompt" },
  log_file_path = nil, -- absolute path to Tabnine log file
})
vim.keymap.set("n", "<leader>qc", "", { noremap = true, callback = require("tabnine.chat").open })
vim.keymap.set("n", "<leader>qd", "<cmd>TabnineDisable<cr>")
vim.keymap.set("n", "<leader>qe", "<cmd>TabnineEnable<cr>")
