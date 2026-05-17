-- ===========================================================================
-- KEYMAPS:
-- vim.keymap.set() uses noremap by default
-- ===========================================================================
local set = vim.keymap.set

set("x", "<leader>p", '"_dP', {
  desc = 'Paste over the visually selected text without overwriting the last yanked/deleted thing. NOTE, can switch to `"_d"0P`',
})
set("i", "<C-v>", "<esc>pa", { desc = "Paste in insert mode and ensure cursor is appended to the end" })
set({ "i" }, "<C-H>", "<C-w>", { desc = "Delete the previous part of the word (up to where your cursor is)" })
set({ "n", "v" }, "<leader>o<CR>", "o<esc>", { desc = "opens line below and remains in insert mode", nowait = true })
set({ "n", "v" }, "<leader>O<CR>", "O<esc>", { desc = "opens line above and remains in insert mode", nowait = true })
set("x", "<leader>p", '"_dP', {
  desc = 'Paste over the visually selected text without overwriting the last yanked/deleted thing. NOTE, can switch to `"_d"0P`',
})
set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })
set("n", "<leader>Y", "mzggyG`z", { desc = "Yank the entire file, and return to where you were initially" })

set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

set("n", "J", function()
  local count = vim.v.count1 -- 1 if no count prefix, n if [n]J
  vim.cmd("normal! mz" .. count .. "J`z")
end, { desc = "Join lines and keep cursor position" })

set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path" })

set("n", "<leader>rp", function()
  if vim.bo.filetype ~= "help" then
    -- See: `:h filename-modifiers`
    --  %  = Current filename
    --  :. = Modifier that makes the filepath relative to the current directory
    -- The colon before gsub just means that the value returned by .expand() is used on gsub
    -- normally, you call gsub doing .gsub(value, pattern, replacement)
    local relative_path = vim.fn.expand("%:."):gsub("\\", "/")
    vim.fn.setreg("+", relative_path)
    vim.api.nvim_put({ relative_path }, "c", true, true)
  end
end, { desc = "Get relative filepath. This assumes you never edit files outside of the cwd." })

