-- lua/nvim/plugins/git.lua

-- ===========================================================================
-- git.lua - handy plugins for Git related operations and appearance
-- ===========================================================================
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

-- ===========================================================================
-- PLUGIN: GITSIGNS.NVIM
-- ===========================================================================
require("gitsigns").setup({
  signs = {
    add = { text = "\u{2590}" }, -- ▏
    change = { text = "\u{2590}" }, -- ▐
    delete = { text = "\u{2590}" }, -- ◦
    topdelete = { text = "\u{25e6}" }, -- ◦
    changedelete = { text = "\u{25cf}" }, -- ●
    untracked = { text = "\u{25cb}" }, -- ○
  },
  signcolumn = true,
  current_line_blame = false,
})
set("n", "<leader>gs", function()
  require("gitsigns").toggle_signs()
end, { desc = "Toggle signs" })
set("n", "]h", function()
  require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })
set("n", "[h", function()
  require("gitsigns").prev_hunk()
end, { desc = "Previous git hunk" })
set("n", "<leader>hs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
set("n", "<leader>hr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
set("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
set("n", "<leader>hb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
set("n", "<leader>hB", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })
set("n", "<leader>hd", function()
  require("gitsigns").diffthis()
end, { desc = "Diff this" })

-- ===========================================================================
-- PLUGIN: VIM-FUGITIVE
-- ===========================================================================
local user_config_group = require("core.augroups").user_config_group
autocmd("BufWinEnter", {
  desc = "Set the width of vim-fugitive",
  group = user_config_group,
  callback = function(ev)
    local filetype = vim.bo[ev.buf].filetype
    if filetype == "fugitive" then
      vim.api.nvim_win_set_width(0, 49)
    end
  end,
})

autocmd({ "WinResized", "VimResized" }, {
  desc = "Maintain vim-fugitive width after layout changes",
  group = user_config_group,
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "fugitive" then
        vim.api.nvim_win_set_width(win, 49)
        break
      end
    end
  end,
})

