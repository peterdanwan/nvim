-- lua/nvim/plugins/treesitter.lua

-- ===========================================================================
-- PLUGIN: NVIM-TREESITTER
-- ===========================================================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local setup_treesitter = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})

  -- Mimics previous behaviour from master branch (not the main branch which we are using)
  -- These are filetype names
  local ensure_installed = {
    "c",
    "cpp",
    "c_sharp",
    "css",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "rust",
    "svelte",
    "typescript",
    "tsx",
    "vue",
    "vim",
    "vimdoc",
  }

  local config = require("nvim-treesitter.config")

  local already_installed = config.get_installed()
  local parsers_to_install = {}

  for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
      table.insert(parsers_to_install, parser)
    end
  end

  if #parsers_to_install > 0 then
    treesitter.install(parsers_to_install)
  end

  local group = augroup("TreeSitterConfig", { clear = true })

  autocmd("FileType", {
    group = group,
    callback = function(args)
      if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
        -- responsible for highlighting
        vim.treesitter.start(args.buf)
        -- responsible for indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

setup_treesitter()

