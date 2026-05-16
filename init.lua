-- init.lua

-- ===========================================================================
-- LEADER KEYS  (must be set before any require so plugins see the right leader)
-- ===========================================================================
vim.g.mapleader = " "
vim.g.lmapleader = " "

-- ===========================================================================
-- CORE FUNCTIONALITY
--
-- Import configurations that aren't scoped to Neovim or VSCode + Neovim Extension
-- ===========================================================================
require("core")

-- ===========================================================================
-- ENVIRONMENT DISPATCH
--
-- vim.g.vscode is automatically set to 1 by the vscode-neovim extension
-- when Neovim is running embedded inside VSCode.  It is nil / unset in a
-- normal terminal Neovim session.
-- ===========================================================================
if vim.g.vscode then
  -- Running inside VSCode via the vscode-neovim extension.
  -- VSCode owns LSP, file trees, terminals, plugins, etc.
  -- Only load the motion / editing keymaps.
  require("vs_code")
else
  -- Pure Neovim session.
  -- Load the full config: options, plugins, LSP, keymaps, everything.
  require("nvim")
end
