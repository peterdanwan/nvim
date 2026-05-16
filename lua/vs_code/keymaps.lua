-- lua/vs_code/keymaps.lua

local set = vim.keymap.set
local unpack = table.unpack or unpack

-- Thin wrapper so callers don't have to spell out vim.fn.VSCodeNotify every time.
-- notify = fire-and-forget (does not wait for VSCode to finish)
local function vsc(command, ...)
  local args = { ... }
  return function()
    vim.fn.VSCodeNotify(command, unpack(args))
  end
end

-- ===========================================================================
-- VSCODE COMMAND WRAPPERS
-- These call into VSCode so you keep your muscle-memory leader bindings.
-- ===========================================================================

-- Save
-- set({ "n", "i", "v" }, "<C-s>", vsc("workbench.action.files.save"), { desc = "Save file" })

-- File explorer
set("n", "<leader>e", vsc("workbench.view.explorer"), { desc = "Toggle Explorer" })

-- Quick open / find files
set("n", "<leader>fp", vsc("workbench.action.quickOpen"), { desc = "Quick open (find file)" })
set("n", "<C-p>", vsc("workbench.action.quickOpen"), { desc = "Quick open (find file)" })

-- Global search (grep)
set("n", "<leader>fg", vsc("workbench.action.findInFiles"), { desc = "Search in files (grep)" })

-- Go to definition / references  (VSCode LSP equivalents)
set("n", "<leader>gd", vsc("editor.action.revealDefinition"), { desc = "Go to definition" })
set("n", "<leader>gD", vsc("editor.action.peekDefinition"), { desc = "Peek definition" })
set("n", "<leader>fr", vsc("editor.action.goToReferences"), { desc = "Go to references" })
set("n", "<leader>ft", vsc("editor.action.goToTypeDefinition"), { desc = "Go to type definition" })
set("n", "<leader>fi", vsc("editor.action.goToImplementation"), { desc = "Go to implementation" })

-- Code actions
set("n", "<leader>ca", vsc("editor.action.quickFix"), { desc = "Code actions / quick fix" })
set("n", "<leader>oi", vsc("editor.action.organizeImports"), { desc = "Organize imports" })

-- Diagnostics
set("n", "<leader>d", vsc("editor.action.marker.next"), { desc = "Next diagnostic" })
set("n", "<leader>nd", vsc("editor.action.marker.next"), { desc = "Next diagnostic" })
set("n", "<leader>pd", vsc("editor.action.marker.prev"), { desc = "Previous diagnostic" })

-- Source control (rough Fugitive equivalent)
set("n", "<leader>gs", vsc("workbench.view.scm"), { desc = "Open Source Control panel" })

