-- lua/core/augroups.lua

-- M stands for module
local M = {}

-- Add different groups to our module as we deem necessary. For now, UserConfig is good enough
M.user_config_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

return M
