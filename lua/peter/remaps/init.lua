-- lua/peter/remaps/init.lua

------------------------------ COMMON SETTINGS ----------------------------
-- Delete visually selected text, send it to the blackhole register ("_d), then (P)aste before the cursor
-- This lets us preserve the contents of our "yank" register ("0)
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Paste the last thing that was yanked
vim.keymap.set({"n", "v"}, "<leader>yp", '"0p')
vim.keymap.set({"n", "v"}, "<leader>yP", '"0P')

-- Add line below while staying in insert mode
vim.keymap.set("n", "<leader>o", 'o<Esc>', {silent = true})
vim.keymap.set("n", "<leader>O", 'O<Esc>', {silent = true})

-- Add pound signs and hyphens
vim.keymap.set("n", "<leader>3", "i#<ESC>", { silent = true})
vim.keymap.set("n", "<leader>h", "i-<ESC>", { silent = true})

------------------------ ENVIRONMENT SPECIFIC SETTINGS --------------------

-- Detect environment
local in_vscode = vim.g.vscode ~= nil

-- Load the appropriate remap module based on environment
if in_vscode then
  require("peter.remaps.vscode-remap")
else
  require("peter.remaps.nvim-remap")
end
