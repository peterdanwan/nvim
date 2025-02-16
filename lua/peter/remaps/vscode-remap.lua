-- lua/peter/vscode-remap.lua

-- Helper function to call VSCode commands
local function vscode_command(command)
  return string.format("<cmd>call VSCodeNotify('%s')<CR>", command)
end

-- VSCode specific mappings
vim.keymap.set({"n", "v"}, "gf", vscode_command("editor.action.openLink"), { silent = true })
vim.keymap.set("n", "<C-p>", vscode_command("workbench.action.quickOpen"), { silent = true })
vim.keymap.set("n", "<leader>pf", vscode_command("workbench.action.quickOpen"), { silent = true })
vim.keymap.set("n", "<leader>fg", vscode_command("workbench.action.findInFiles"), { silent = true })