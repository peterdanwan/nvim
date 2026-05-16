-- lua/nvim/opts.lua

-- ===========================================================================
-- OPTIONS (Neovim only)
--
-- Display and rendering options that only make sense in a terminal Neovim
-- session. VSCode owns all of this when running via the neovim extension:
-- line numbers, gutter, cursor shape, folds, syntax highlighting, etc.
-- None of these have any effect (or can cause conflicts) in VSCode, so they
-- live here rather than in lua/core/opts.lua.
-- ===========================================================================
local opt = vim.opt

-- ---------------------------------------------------------------------------
-- COLORS
-- ---------------------------------------------------------------------------
opt.termguicolors = true
-- vim.cmd.colorscheme('habamax') -- a colorscheme is not an opt since it sets a whole bunch of things...

-- ---------------------------------------------------------------------------
-- LINE NUMBERS & CURSOR LINE
-- ---------------------------------------------------------------------------
opt.number = true -- line number
opt.relativenumber = true -- relative line numbers
opt.cursorline = true -- highlight current line

-- ---------------------------------------------------------------------------
-- LAYOUT
-- ---------------------------------------------------------------------------
opt.wrap = false -- do not wrap lines (VSCode equivalent: editor.wordWrap)
opt.scrolloff = 10 -- keep 10 lines above/below the cursor
-- opt.sidescrolloff = 10 -- keep 10 lines left/right of cursor

-- opt.splitbelow = true -- horizontal splits go below (default is nosplitbelow)
-- opt.splitright = true -- vertical splits go right (default is nosplitright)

-- ---------------------------------------------------------------------------
-- GUTTER / SIGN COLUMN
-- ---------------------------------------------------------------------------
opt.signcolumn = "yes:2" -- always show a signcolumn for warnings,errors etc. with a column-width of 2
-- opt.colorcolumn = "100" -- show a column at 100 position chars (useful for adhering to code standards in projects)

-- ---------------------------------------------------------------------------
-- UI CHROME
-- ---------------------------------------------------------------------------
opt.showmatch = false -- highlights matching brackets as you're typing (PW: I like this as false instead of true)
opt.cmdheight = 1 -- single line command line
opt.showmode = false -- do not show the mode on the commandline, (we will be displaying the mode in the statusline)
-- opt.pumheight = 30 -- popup menu height
opt.pumblend = 10 -- popup menu transparency
opt.winblend = 0 -- floating window transparency

-- ---------------------------------------------------------------------------
-- CONCEALMENT
-- ---------------------------------------------------------------------------
opt.conceallevel = 0 -- do not hide markup
opt.concealcursor = "" -- do not hide cursorline in markup

-- ---------------------------------------------------------------------------
-- SYNTAX
-- ---------------------------------------------------------------------------
-- VSCode does its own syntax highlighting via TextMate grammars / language servers;
-- synmaxcol is only relevant to Neovim's own highlighting engine.
opt.synmaxcol = 300 -- syntax highlighting limit (PW: ... why?)
-- (guards against Neovim hanging on very long minified lines)

-- ---------------------------------------------------------------------------
-- LISTCHARS (visible whitespace)
-- ---------------------------------------------------------------------------
-- VSCode ignores these entirely — it renders the buffer itself. Use
-- editor.renderWhitespace / editor.renderControlCharacters in settings.json
-- to get the equivalent behaviour in VSCode.
opt.list = true -- use listchars to see things like spaces, tabs, trailing spaces, etc.
opt.listchars = {
  tab = "→ ", -- Tab character (needs two chars: leader + trailing)
  lead = "·", -- For leading indentation
  trail = "•", -- Trailing whitespace (useful to spot accidental spaces)
  nbsp = "␣", -- Non-breaking space
  -- space = "·", -- Regular space (setting this is too noisy)
  -- eol   = "¬", -- End of line (setting this is too noisy)
}

-- ---------------------------------------------------------------------------
-- FILLCHARS
-- ---------------------------------------------------------------------------
opt.fillchars = {
  eob = " ", -- hide the ~ markers past the end of a buffer
  vert = " ", -- makes vertical splits have no vertical character (|)
}

-- ---------------------------------------------------------------------------
-- CURSOR SHAPE
-- ---------------------------------------------------------------------------
-- VSCode controls cursor shape through its own settings (editor.cursorStyle,
-- editor.cursorBlinking). This only applies in a terminal session.
opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- ---------------------------------------------------------------------------
-- FOLDING
-- ---------------------------------------------------------------------------
-- VSCode has its own folding engine driven by the language server / syntax
-- provider. Neovim's fold settings have no effect there.
-- Folding requires "treesitter" available at runtime; safe fallback if not available
-- `:h fold-commands`
opt.foldmethod = "expr" -- use expression for folding (default is manual)
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding (default)
opt.foldlevel = 99 -- start with all folds open

-- ---------------------------------------------------------------------------
-- WILDMENU (command-line completion)
-- ---------------------------------------------------------------------------
-- Not meaningful in VSCode, which has the command palette instead.
opt.wildmenu = true -- tab completion (default is true)
opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab (default is "full")

-- ---------------------------------------------------------------------------
-- PERFORMANCE
-- ---------------------------------------------------------------------------
opt.redrawtime = 10000 -- increase neovim redraw tolerance (2000 by default)
-- (helps on large files where treesitter/syntax is slow to finish)

