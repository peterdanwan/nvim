-- lua/nvim/plugins/init.lua

-- ===========================================================================
-- PLUGINS (vim.pack)
-- ===========================================================================

-- Installs/downloads repos to your computer
-- By default, downloads the programs to the optional plugin directory: nvim-data/site/pack/core/opt
local function download(opts)
  vim.pack.add(opts)
end

-- packadd loads the program (sources the program) from the optional plugin directory
local function packadd(name)
  vim.cmd("packadd " .. name)
end

download({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  },
  "https://github.com/nvim-lualine/lualine.nvim",
  -- "https://github.com/lewis6991/satellite.nvim",
  "https://github.com/dstein64/nvim-scrollview",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-lua/plenary.nvim",
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      {
        src = "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
      },
    },
  },
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "https://github.com/nvim-lua/plenary.nvim",
    },
  },
  {
    -- Worth mentioning that you need to have the tree-sitter-cli installed via `npm i -G tree-sitter-cli`
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  -- Language Server Protocols
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/creativenull/efmls-configs-nvim",
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/akinsho/toggleterm.nvim",
})

packadd("lualine.nvim")
-- packadd("satellite.nvim")
packadd("nvim-scrollview")
packadd("gitsigns.nvim")
packadd("vim-fugitive")
packadd("mini.nvim")
packadd("nvim-web-devicons")
packadd("nvim-tree.lua")
packadd("plenary.nvim")
packadd("telescope.nvim")
packadd("harpoon")
packadd("nvim-treesitter")

-- LSP related installs
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("efmls-configs-nvim")
packadd("blink.cmp")
packadd("friendly-snippets")
packadd("LuaSnip")
packadd("nvim-ts-autotag")
packadd("which-key.nvim")

packadd("toggleterm.nvim")

-- Require config files for plugins
require("nvim.plugins.ui")
require("nvim.plugins.git")
require("nvim.plugins.editor")
require("nvim.plugins.telescope")
require("nvim.plugins.treesitter")
require("nvim.plugins.lsp")

