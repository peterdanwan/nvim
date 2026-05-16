-- lua/vs_code/opts.lua

-- ===========================================================================
-- OPTIONS (VSCode + Neovim Extension only)
--
-- This file is for two purposes:
--   1. Overrides of core opts that need different values inside VSCode.
--   2. Documentation of what VSCode owns so you know not to fight it.
--
-- VSCode owns: line numbers, gutter, cursor shape, folds, syntax highlighting,
-- word wrap, scrolling, popups, color themes, and all visual rendering.
-- Do not attempt to set those here — they have no effect and cause confusion.
-- ===========================================================================
local opt = vim.opt

-- ---------------------------------------------------------------------------
-- TIMING
-- ---------------------------------------------------------------------------
-- VSCode's own debounce and rendering pipeline means a tighter timeoutlen
-- can cause mapped sequences to misfire. Loosen it slightly vs. core.
opt.timeoutlen = 1000 -- (core sets 500; VSCode's input handling needs more room)

-- ---------------------------------------------------------------------------
-- COMPLETION
-- ---------------------------------------------------------------------------
-- VSCode owns the completion menu entirely via its language server integration.
-- Disable Neovim's built-in popup so the two don't fight each other.
opt.completeopt = "menu,menuone,noselect" -- let VSCode's completion take over

-- ---------------------------------------------------------------------------
-- COMMAND LINE
-- ---------------------------------------------------------------------------
-- Neovim's command line is still accessible in VSCode (via the neovim-ui or
-- : commands), but it's floating and minimal. Collapse it to avoid ghost space.
opt.cmdheight = 1 -- single line command line

-- ---------------------------------------------------------------------------
-- SCROLLING
-- ---------------------------------------------------------------------------
-- VSCode controls its own viewport, but scrolloff is respected by the extension
-- when moving the Neovim cursor, so it's worth keeping a reasonable value.
opt.scrolloff = 8 -- (slightly less than core's 10 to avoid VSCode fighting it
--  near the top/bottom of the visible area)

-- ---------------------------------------------------------------------------
-- CONCEALMENT
-- ---------------------------------------------------------------------------
-- VSCode renders markdown, JSX, etc. through its own engine. Concealment from
-- Neovim's side can cause cursor position drift, so keep it off.
opt.conceallevel = 0 -- do not hide markup
opt.concealcursor = "" -- do not hide cursorline in markup

