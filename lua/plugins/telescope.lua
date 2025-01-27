-- lua/plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- Initialize telescope and map keybindings to some of its functions
    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  end
}
