-- lua/core/opts.lua

-- ===========================================================================
-- OPTIONS
--
-- Core options that can be shared by both Neovim and VSCode + Neovim Extension
--
-- Rule of thumb: if it affects how *editing behaves*, it belongs here.
--                if it affects how *things look*, it belongs in nvim/opts.lua.
-- ===========================================================================
local opt = vim.opt

-- ---------------------------------------------------------------------------
-- CLIPBOARD
-- ---------------------------------------------------------------------------
opt.clipboard = "unnamedplus" -- syncs yank, delete, and put operations with the system clipboard

-- ---------------------------------------------------------------------------
-- INDENTATION
-- ---------------------------------------------------------------------------
opt.tabstop = 2 -- tabwidth
opt.shiftwidth = 2 -- indent width
opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspace
opt.expandtab = true -- soft tab stop not tabs on tab/backspace
opt.smartindent = true -- smart auto-indent
opt.autoindent = true -- copy indent from current line

-- ---------------------------------------------------------------------------
-- SEARCH
-- ---------------------------------------------------------------------------
opt.ignorecase = true -- case insensitive search when using `/`
opt.smartcase = true -- case sensitive when using `/`, if you use any uppercase
opt.hlsearch = true -- highlight search matches
opt.incsearch = true -- show matches as you type

-- ---------------------------------------------------------------------------
-- COMPLETION
-- ---------------------------------------------------------------------------
-- VSCode uses its own completion UI, but completeopt still governs Neovim's
-- built-in completion engine which can be triggered in the embedded session.
opt.completeopt = "menuone,noinsert,noselect,popup" -- completion options (probably useful in relation with lsp info and snippets)

-- ---------------------------------------------------------------------------
-- UNDO (persistent across sessions)
-- ---------------------------------------------------------------------------
-- Grants the ability to undo changes on buffers that persists across Neovim sessions
local undodir = vim.fn.stdpath("data") .. "/undodir" -- nvim-data/undodir
local createUndoDirIfNotExist = function()
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
    vim.notify("nvim-data/undodir created")
  end
end

opt.undofile = true -- do create an undo file
opt.undodir = undodir
createUndoDirIfNotExist()

-- ---------------------------------------------------------------------------
-- FILE SAFETY
-- ---------------------------------------------------------------------------
opt.backup = false -- do not create a backup file
opt.writebackup = false -- do not write to a backup file
opt.swapfile = false -- do not create a swapfile (PW: Idk yet)

-- ---------------------------------------------------------------------------
-- TIMING
-- ---------------------------------------------------------------------------
opt.updatetime = 300 -- faster completion (PW: Idk)
opt.timeoutlen = 500 -- timeout duration (PW: Idk)

-- ---------------------------------------------------------------------------
-- BUFFER / SESSION BEHAVIOUR
-- ---------------------------------------------------------------------------
opt.autoread = true -- auto-reload changes made outside of neovim (e.g., a VSCode edit, npm i)
opt.autowrite = false -- do not auto-save

opt.hidden = true -- allow hidden buffers
opt.errorbells = false -- no error sounds (false by default)
opt.backspace = "indent,eol,start" -- better backspace behaviour (default anyways)
opt.autochdir = false -- do not autochange directories which is based off the directory containing the file of the current buffer (default is false)
-- opt.iskeyword:append("-") -- include `-` as part of a 'word' try highlighting this-word
opt.path:append("**") -- include subdirs in search
opt.selection = "inclusive" -- include last char in selection (inclusive by default)
opt.mouse = "a" -- enable mouse support
opt.modifiable = true -- allow buffer modifications (true by default)
opt.encoding = "utf-8" -- set encoding (utf-8 by default)

-- ---------------------------------------------------------------------------
-- DIFF
-- ---------------------------------------------------------------------------
opt.diffopt:append("linematch:60") -- improve diff display (linematch is 40 by default)

