-- lua/peter/nvim-remap.lua

-- Gets back to the netrc Explorer view 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Use Ctrl + q to enter Visual Block Mode?
vim.keymap.set("n", "<C-q>", "<C-v>", { noremap = true })

-- Show hover documentation
vim.keymap.set({"n", "v"}, "gh", vim.lsp.buf.hover, { desc = "Show hover documentation" })
