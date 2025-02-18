-- lua/plugins/catppuccin.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function() -- Lazy's config function calls require("package").setup(opts) by default
    vim.cmd.colorscheme "catppuccin"
    -- transparent_background = false
-- Set transparent highlights AFTER colorscheme
   vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  end
}
