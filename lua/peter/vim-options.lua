-- lua/peter/vim-options.lua
---------------------- Basic settings ----------------------
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
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

-- Allows me to be able to use system clipboard
vim.opt.clipboard:append("unnamedplus")
vim.g.mapleader = " "

-- Enable transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
