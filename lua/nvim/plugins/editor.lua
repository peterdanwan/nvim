-- lua/nvim/plugins/editor.lua
-- ===========================================================================
-- editor.lua: core editor features such as file trees, seeing your custom shortcuts, integrated terminals, etc.
-- ===========================================================================

-- ===========================================================================
-- PLUGIN: MINI.NVIM
-- ===========================================================================
require("mini.ai").setup({}) -- (a)round (i)nsert - for visually selecting objects
require("mini.comment").setup({})
require("mini.move").setup({})
-- require("mini.surround").setup({
--   -- mappings = {
--   --   add = "<leader>sa",
--   --   delete = "<leader>sd",
--   --   replace = "<leader>sr",
--   --   find = "<leader>sf", -- find surrounding to the right
--   --   find_left = "<leader>sF", -- find surrounding to the left
--   --   highlight = "<leader>sh", -- highlight surrounding
--   --   update_n_lines = "<leader>sn", -- update n_lines search range
--   -- },
--   custom_surroundings = {
--     -- Markdown bold: **text**
--     -- Use 'b' as the key so it doesn't conflict with single `*`
--     ["b"] = {
--       input = { "%*%*", "%*%*" },
--       output = { left = "**", right = "**" },
--     },
--
--     -- Markdown italic / "underline": _text_
--     ["_"] = {
--       input = { "_", "_" },
--       output = { left = "_", right = "_" },
--     },
--   },
-- })

require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})

-- ===========================================================================
-- PLUGIN: NVIM-TREE.LUA
-- ===========================================================================
require("nvim-tree").setup({
  -- :h nvim-tree-setup
  -- :h nvim-tree-config-default
  -- :h nvim-tree-config

  view = {
    width = 50,
    number = true,
    relativenumber = true,
    signcolumn = "no",
  },
  filters = {
    dotfiles = false,
    git_ignored = false,
  },
  renderer = {
    group_empty = true,
    root_folder_label = vim.fn.expand("%:."):gsub("\\", "/"),
  },
  hijack_netrw = false,
  update_focused_file = {
    enable = true,
    update_root = {
      enable = true,
    },
  },
  prefer_startup_root = true,
})

local set = vim.keymap.set
local set_hl = vim.api.nvim_set_hl

set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

set_hl(0, "NvimTreeNormalNC", { bg = "None" })
set_hl(0, "NvimTreeStatusLine", { bg = "None" })
set_hl(0, "NvimTreeStatusLineNC", { bg = "None" })
set_hl(0, "SignColumn", { bg = "None" })
set_hl(0, "NvimTreeSignColumn", { bg = "None" })
set_hl(0, "NvimTreeNormal", { bg = "None" })
-- set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "None" })
set_hl(0, "NvimTreeWinSeparator", { fg = "None", bg = "None" })
set_hl(0, "NvimTreeEndOfBuffer", { bg = "None" })

-- ===========================================================================
-- TOGGLETERM.NVIM
-- ===========================================================================
require("toggleterm").setup({
  size = 15,
  direction = "horizontal",
  shade_terminals = false,
  persist_size = true,
  persist_mode = true,
  shell = vim.fn.exepath("fish") ~= "" and "fish" or vim.o.shell,
})
set({ "n", "i", "t", "v" }, "<C-`>", function()
  require("toggleterm").toggle(vim.v.count == 0 and 1 or vim.v.count)
end, { desc = "Toggle terminal" })
set("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })

