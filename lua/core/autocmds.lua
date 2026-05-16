-- lua/core/autocmds.lua

-- ===========================================================================
-- AUTOCOMMANDS:
-- BufWinEnter fires each time a buffer appears in a window, even on reuse
-- FileType only fires once when the filetype is assigned to the buffer (and not upon revisiting a buffer for a particular file)
-- ===========================================================================
local autocmd = vim.api.nvim_create_autocmd

-- clear = true means that when the augroup is resourced, it'll nuke the existing autocommands under it and remake them
-- This prevents the same autocommands from being built over and over again, which can lead to bugs where outputs are duplicated.
local user_config_group = require("core.augroups").user_config_group

-- Core
autocmd("TextYankPost", {
  desc = "After yanking, highlights the yanked text",
  group = user_config_group,
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  group = user_config_group,
  callback = function()
    if vim.o.diff then -- don't run logic in diff mode
      return
    end

    -- Get the last position using the current buffer (0) and the (") mark that stores the last row and column position
    local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {row, col}
    local num_lines = vim.api.nvim_buf_line_count(0)

    -- Recall that Lua is crazy and indexes its tables starting at 1
    local row = last_pos[1]

    -- Checks if the row somehow starts:
    -- 1. before line 1 (impossible to have a line number of 0)
    -- 2. exceeds the last line of the file (perhaps another program edited the file)
    local row_out_of_bounds = function()
      return row < 1 or row > num_lines
    end

    if row_out_of_bounds() then
      return
    end

    -- Do a (p)rotected (c)all to nvim_win_set_cursor, passing the current buffer and last_pos
    -- Errors are caught and will return a status code
    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

autocmd({ "FocusGained", "BufEnter", "TermClose" }, {
  group = user_config_group,
  command = "checktime",
  desc = "Reload files changed outside of Neovim (makes autoread actually work)",
})

