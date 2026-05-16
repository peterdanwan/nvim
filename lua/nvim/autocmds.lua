-- lua/nvim/autocmds.lua

-- ===========================================================================
-- AUTOCOMMANDS:
-- BufWinEnter fires each time a buffer appears in a window, even on reuse
-- FileType only fires once when the filetype is assigned to the buffer (and not upon revisiting a buffer for a particular file)
-- ===========================================================================
local autocmd = vim.api.nvim_create_autocmd

-- clear = true means that when the augroup is resourced, it'll nuke the existing autocommands under it and remake them
-- This prevents the same autocommands from being built over and over again, which can lead to bugs where outputs are duplicated.
local user_config_group = require("core.augroups").user_config_group

-- Neovim specific
autocmd("BufWinEnter", {
  desc = "Ensure specific files are opened to the left",
  group = user_config_group,
  callback = function(ev)
    local filetype = vim.bo[ev.buf].filetype -- read NOW, for THIS buffer
    local sp_files = { help = true, fugitive = true }

    if sp_files[filetype] then
      vim.cmd("wincmd H")
    end
  end,
})

autocmd("BufWinEnter", {
  desc = "Force line numbers on specific filetypes",
  group = user_config_group,
  callback = function(ev)
    local filetype = vim.bo[ev.buf].filetype -- read NOW, for THIS buffer
    local sp_files = { help = true, man = true, netrw = true }
    local win = vim.api.nvim_get_current_win()

    if sp_files[filetype] then
      vim.api.nvim_set_option_value("number", true, { win = win })
      vim.api.nvim_set_option_value("relativenumber", true, { win = win })
      vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
    else
      vim.api.nvim_set_option_value("signcolumn", "yes:2", { win = win })
    end
  end,
})

autocmd("FileType", {
  pattern = { "netrw", "help" },
  group = user_config_group,
  desc = "Force line numbers on netrw",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value("number", true, { win = win })
    vim.api.nvim_set_option_value("relativenumber", true, { win = win })
    vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
  end,
})

autocmd("BufWritePre", {
  group = user_config_group,
  pattern = {
    "*.lua",
    "*.py",
    "*.go",
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.json",
    "*.css",
    "*.scss",
    "*.html",
    "*.sh",
    "*.bash",
    "*.zsh",
    "*.c",
    "*.cpp",
    "*.h",
    "*.hpp",
    "*.vue",
  },
  callback = function(args)
    -- avoid formatting non-file buffers (helps prevent weird write prompts)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    if not vim.bo[args.buf].modifiable then
      return
    end
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    local has_efm = false
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if c.name == "efm" then
        has_efm = true
        break
      end
    end
    if not has_efm then
      return
    end

    pcall(function()
      local view = vim.fn.winsaveview()
      vim.lsp.buf.format({
        bufnr = args.buf,
        timeout_ms = 2000,
        filter = function(c)
          return c.name == "efm"
        end,
      })
      vim.fn.winrestview(view)
    end)
  end,
})

