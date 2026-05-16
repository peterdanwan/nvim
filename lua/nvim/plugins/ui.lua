-- lua/nvim/plugins/ui.lua
-- ===========================================================================
-- UI: influences the appearance of Neovim in the terminal (not VSCode)
-- ===========================================================================

-- ===========================================================================
-- PLUGIN: CATPPUCCIN
-- ===========================================================================
vim.cmd.colorscheme("catppuccin-mocha")

-- ===========================================================================
-- COLORS:
-- Tips:
-- 1. run `:Inspect` while hovering over text to see what highlight group they are
-- 2. The 0 is the (n)ame(s)pace_id of the current buffer
-- 3. To find a list of highlight group names for the 2nd argument, run:
--    - `:hi`
-- 4. When you have a verbose ex-command consider (e)diting a (n)ew, unnamed buffer that isn't
--    - `:enew | put =execute('hi')
-- 5. Set these things after our colorscheme loads, since colorschemes override these settings
-- ===========================================================================
local set_hl = vim.api.nvim_set_hl

set_hl(0, "Normal", { bg = "none" }) -- Make the current window transparent
set_hl(0, "NormalFloat", { bg = "none" }) -- Make floating windows transparent
set_hl(0, "NormalNC", { bg = "none" }) -- Make the (N)on (C)urrent window transparent

set_hl(0, "LineNrAbove", { fg = "#51B3EC", bold = true, bg = "NONE" })
set_hl(0, "LineNr", { fg = "white", bold = true, bg = "NONE" })
set_hl(0, "LineNrBelow", { fg = "#FB508F", bold = true, bg = "NONE" })

-- I.e., for popup windows
-- set_hl(0, "NormalFloat", { link = "Normal" })
set_hl(0, "FloatBorder", { fg = "#b4befe" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "StatusLine", { bg = "none" })
set_hl(0, "StatusLineNC", { bg = "none" })
set_hl(0, "NvimTreeStatusLine", { bg = "none" })
set_hl(0, "NvimTreeStatusLineNC", { bg = "none" })
-- set_hl(0, "MsgArea", { bg = "none" })
set_hl(0, "TabLine", { bg = "none" })
-- set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
set_hl(0, "TabLineFill", { bg = "none", fg = "none" })
set_hl(0, "TabLineSel", { bg = "none" })
set_hl(0, "ColorColumn", { bg = "none" })
set_hl(0, "WinSeparator", { fg = "none", bg = "none" })

-- ===========================================================================
-- PLUGIN: LUALINE.NVIM
-- ===========================================================================
local rosewater = "#dc8a78"

local my_sections = {
  lualine_a = { "mode" },
  lualine_b = { "branch", "diff", "diagnostics" },
  lualine_c = {
    {
      "filename",
      path = 1, -- relative path
      -- function()
      --   local relative_path = vim.fn.expand("%:."):gsub("\\", "/")
      --   vim.fn.setreg("+", relative_path)
      --   vim.api.nvim_put({ relative_path }, "c", true, true)
      -- end,
    },
  },
  lualine_x = { "encoding", "fileformat", "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

require("lualine").setup({
  options = {
    globalstatus = false,
    theme = vim.tbl_deep_extend("force", require("lualine.themes.auto"), {
      normal = { c = { bg = "none" } },
      insert = { c = { bg = "none" } },
      visual = { c = { bg = "none" } },
      replace = { c = { bg = "none" } },
      command = { c = { bg = "none" } },
      inactive = { c = { bg = "none" } },
    }),
  },
  sections = my_sections,
  inactive_sections = my_sections,
})

-- Rosewater tint on all inactive statusline sections
set_hl(0, "lualine_a_inactive", { fg = rosewater, bg = "none", bold = true })
set_hl(0, "lualine_b_inactive", { fg = rosewater, bg = "none" })
set_hl(0, "lualine_c_inactive", { fg = rosewater, bg = "none" })

-- -- ===========================================================================
-- -- PLUGIN: SATELLITE.NVIM
-- -- ===========================================================================
-- local scrollbar_enabled = true
--
-- require("satellite").setup({
--   current_only = false, -- show scrollbar only on the focused window
--   winblend = 50, -- transparency of the scrollbar
--   zindex = 40,
--   excluded_filetypes = { "NvimTree", "help", "fugitive", "terminal" },
--   width = 3,
--   handlers = {
--     cursor = { enable = true },
--     marks = { enable = true, show_builtins = false },
--     search = { enable = true },
--     diagnostic = {
--       enable = true,
--       signs = { "-", "=", "≡" },
--       min_severity = vim.diagnostic.severity.HINT,
--     },
--     gitsigns = { enable = true },
--   },
-- })
--
-- -- <leader>sb → toggle scrollbar visibility
-- vim.keymap.set("n", "<leader>sb", function()
--   scrollbar_enabled = not scrollbar_enabled
--   if scrollbar_enabled then
--     vim.cmd("SatelliteEnable")
--   else
--     vim.cmd("SatelliteDisable")
--   end
--   vim.notify("Scrollbar " .. (scrollbar_enabled and "shown" or "hidden"))
-- end, { desc = "Toggle scrollbar" })
--
-- set_hl(0, "SatelliteCursor", { fg = "#7aa2f7" }) -- thumb color
-- set_hl(0, "SatelliteBar", { bg = "#FFFFFF" }) -- track color

-- ===========================================================================
-- PLUGIN: NVIM-SCROLLVIEW
-- ===========================================================================
local scrollbar_enabled = true

require("scrollview").setup({
  current_only = false,
  winblend = 50,
  width = 3,
  excluded_filetypes = { "NvimTree", "help", "fugitive", "terminal" },
  -- Signs (satellite equivalents)
  signs_on_startup = { "all" },
  diagnostics_severities = {
    vim.diagnostic.severity.HINT,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.ERROR,
  },
})

-- <leader>sb → toggle scrollbar visibility (same keybind as before)
vim.keymap.set("n", "<leader>sb", function()
  scrollbar_enabled = not scrollbar_enabled
  if scrollbar_enabled then
    vim.cmd("ScrollViewEnable")
  else
    vim.cmd("ScrollViewDisable")
  end
  vim.notify("Scrollbar " .. (scrollbar_enabled and "shown" or "hidden"))
end, { desc = "Toggle scrollbar" })

set_hl(0, "ScrollView", { bg = "#7aa2f7" }) -- thumb color
set_hl(0, "ScrollViewSearch", { bg = "#fab387" }) -- search match markers

