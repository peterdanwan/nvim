-- lua/peter/vim-options.lua

---------------------- Basic settings ----------------------

--- Using the "Vim API" (i.e., vim.cmd() calls) to execute various "Ex commands"
vim.cmd("set expandtab")
vim.cmd("set tabstop=8")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set cursorline")
vim.cmd([[
  augroup NetrwLineNumbers
    autocmd!
    autocmd FileType netrw setl number relativenumber
  augroup END
]])

-- Markdown-specific indentation settings, using the "Nvim API" written in C (i.e., vim.api.*)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.shiftwidth = 3
    vim.opt.softtabstop = 3
  end,
})

-- Allows me to be able to use system clipboard, using the "Lua API", (i.e., vim.opt.*)
vim.opt.clipboard:append("unnamedplus")

-- Enable transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })

-- Make Line numbers a little more readable
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = '#51B3EC', bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = 'white', bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = '#FB508F', bold = true })
