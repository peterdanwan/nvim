-- lua/plugins/telescope.lua

return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- Get telescope builtin and setup
    local builtin = require("telescope.builtin")
    local telescope = require("telescope")

    -- Configure telescope
    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<Tab>"] = "move_selection_next",
            ["<S-Tab>"] = "move_selection_previous",
          }
        }
      }
    })

    -- Set keymaps
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  end
}
