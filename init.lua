-- init.lua

-- Get Neovim's "data" path and concatenate "/lazy/lazy.nvim" to it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- [[
--    vim.uv and vim.loop are both "interfaces" that use libuv (UV standing for "ultraviolet")
--    - the code below has a preference for vim.uv (the newer way to access libuv)
--    - we fall back to vim.loop if vim.uv isn't available
--    - whether we have vim.uv or vim.loop, we use the fs_stat method to check for the presence
--      of our lazy.nvim configuration file
--    - so if the path to lazy doesn't exist, we git clone the lazy.nvim repository
-- ]]
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end

-- lazyvim requires we define our leader key before adding lazy to our runtime path
vim.g.mapleader = " "
vim.opt.rtp:prepend(lazypath)

-- [[ 
--    Configuration options for lazy 
--    - we have none so far
--    - NOTE: it's good practice to define the variable locally
-- ]]
local opts = {}

require("lazy").setup("plugins", opts)
require("peter")

vim.keymap.set('n', '<C-q>', '<C-v>', { noremap = true })
