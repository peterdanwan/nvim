-- lua/peter/remap.lua
-- Sets the "leader" key that lets us write our own custom commands
vim.g.mapleader = " "

-- Gets back to the netrc Explorer view 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Replace text without losing my paste register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Send visual selection to windows clipboard (This is for Windows)
vim.keymap.set("x", "<leader>ys", ":w +y")

-- 
vim.keymap.set("n", '<C-q>', '<C-v>', { noremap = true })
