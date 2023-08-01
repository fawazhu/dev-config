vim.keymap.set('n', '<leader>tm', function() require('harpoon.mark').add_file() end)
vim.keymap.set('n', '<leader>tr', function() require('harpoon.mark').remove_file() end)
vim.keymap.set('n', '<leader>tn', function() require('harpoon.ui').toggle_quick_menu() end)
for j = 1, 9, 1 do
  vim.keymap.set("n", "<leader>t"..j, function() require("harpoon.ui").nav_file(j) end)
end

