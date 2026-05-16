-- lua/nvim/keymaps.lua

local set = vim.keymap.set
set({ "n", "v" }, "<leader>so", "<cmd>so %<CR>", { desc = "Source the current (%) file" })
set(
  "n",
  "<C-_>",
  "gcc",
  { desc = "TODO: Comment out the current line AND return to where you were initially", remap = true }
)
set(
  "v",
  "<C-_>",
  "gc",
  { desc = "TODO: Comment out the current line AND return to where you were initially", remap = true }
)
set(
  "i",
  "<C-_>",
  "<Esc>gcci",
  { desc = "TODO: Comment out the current line AND return to where you were relative ", remap = true }
)
set("n", "<C-\\>", "gcc", { desc = "Comment out the current line", remap = true })
set("v", "<C-\\>", "igc", { desc = "Comment out the current line" })

set({ "n", "v" }, "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, {
  expr = true,
  silent = true,
  desc = "linewrap aware down (putting a count will still make you move down by actual line numbers)",
})

set({ "n", "v" }, "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, {
  expr = true,
  silent = true,
  desc = "linewrap aware up (putting a count will still make you move up by actual line numbers)",
})
set({ "n", "v" }, "<leader>wo", "<C-w>o", { desc = "Close other windows, but keep this (w)indow (o)pen" })
set({ "n", "v" }, "<leader>wk", "<C-w>k", { desc = "Go up by one window" })
set({ "n", "v" }, "<leader>wj", "<C-w>j", { desc = "Go down by one window" })
set({ "n", "v" }, "<leader>wh", "<C-w>h", { desc = "Go left by one window" })
set({ "n", "v" }, "<leader>wl", "<C-w>l", { desc = "Go right by one window" })

set({ "n", "v", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Write to file (save file)" })

set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Increase window width" })

set("n", "<C-Up>", "<C-w>5<", { desc = "Increase the current window size to the left" })
set("n", "<M-,>", "<C-w>5<", { desc = "Increase the current window size to the left" })
set("n", "<C-Down>", "<C-w>5<", { desc = "Increase the current window size to the left" })
set("n", "<M-.>", "<C-w>5>", { desc = "Increase the current window size to the left" }) -- Expand right

set("n", "<M-t>", "<C-w>5+") -- Make taller
set("n", "<M-s>", "<C-w>5-") -- Make shorter

set({ "n", "v" }, "<leader>m", "<cmd>messages<CR>", { desc = "Show vim.notify messages" })

set(
  "n",
  "<C-j>",
  function()
    -- Original: ':m .+1<CR>=='
    -- :[range]m[ove] {address}
    local count = vim.v.count1 -- 1 if no count prefix, n if [n]<C-j>

    -- Range = the current line (this is the default if not explicitly stated)
    local range = "."

    -- Address = n line(s) below current
    local address = ".+" .. count

    -- Moves the current line below
    vim.cmd(range .. "m" .. address)

    -- Goes into normal mode and state you will use no mappings via `!`
    -- Re-indent after moving
    vim.cmd("normal! ==")
  end,
  { desc = "Move line down. Remember to <Esc> when done. Pressing u in visual mode makes the selected text undercase" }
)

set("n", "<C-k>", function()
  -- Original: ":m .-2<CR>=="
  -- :[range]m[ove] {address}
  local count = vim.v.count1 -- 1 if no count prefix, n if [n]<C-j>

  -- Range = the current line (this is the default if not explicitly stated)
  local range = "."

  -- Address = at least two lines above the current line
  -- :move places the range *below* the address
  -- therefore, landing below (.-2) = moving up by 1 net
  local address = ".-" .. (count + 1)

  -- Moves the current line below
  vim.cmd(range .. "m" .. address)

  -- Re-indent after moving (normal! = no remaps)
  vim.cmd("normal! ==")
end, { desc = "Move line up" })

set("v", "<C-j>", function()
  -- Original: ":m '>+1<CR>gv=gv"
  local count = vim.v.count1

  -- Exit visual mode first so '< and '> marks are committed
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  -- Range = the entire visual selection
  local range = "'<,'>"

  -- Address = count lines below the END of the selection
  -- Same rule: lands *below* address, so '>+count is correct (no overshoot needed)
  local address = "'>" .. "+" .. count

  vim.cmd(range .. "move " .. address)

  -- gv = reselect the last visually selected section (i.e., the moved section)
  -- =  = after gv will re-indent the visually selected section (deselects the visually selected text)
  -- gv = reselects again (remaining in visual mode)
  vim.cmd("normal! gv=gv")
end, { desc = "Move selection down" })

-- vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<C-k>", function()
  local count = vim.v.count1

  -- Exit visual mode first so '< and '> marks are committed
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  -- Range = the entire visual selection
  local range = "'<,'>"

  -- Address = relative to the START of the selection this time
  -- Same overshoot rule: need -(count+1) to net -count
  local address = "'<-" .. (count + 1)

  vim.cmd(range .. "move " .. address)
  vim.cmd("normal! gv=gv")
end, { desc = "Move selection up" })

vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

vim.keymap.set(
  { "n", "v" },
  "<F2>",
  vim.lsp.buf.rename,
  { desc = "Rename (only works when you have a language server for the filetype)" }
)

set(
  "x",
  "<leader>x",
  '"_d',
  { desc = 'Delete the visually selected text without saving to the "" register or "1 register' }
)

