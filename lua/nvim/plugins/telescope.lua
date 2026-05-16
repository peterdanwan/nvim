-- lua/nvim/plugins/telescope.lua
-- ===========================================================================
-- telescope.lua: configurations for telescope and other extensions that use it to fuzzy find files
-- ===========================================================================

-- ===========================================================================
-- PLUGIN: TELESCOPE.NVIM
-- ===========================================================================
local builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    mappings = {
      -- As with many popup windows, default mappings for (n)ext move_selection_next and (p)rev move_selection_previous are: <C-n> <C-p> respectively
      i = {
        ["<Tab>"] = "move_selection_next",
        ["<S-Tab>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
    file_ignore_patterns = {
      "%.docx",
      "%.pptx",
      "%.pdf",
    },
  },
})

local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local user_config_group = require("core.augroups").user_config_group

-- PW: figure out when you can pass nnoremap = true (perhaps it's when right hand side has commands like `:<some_command`)
set("n", "<leader>fp", function()
  builtin.find_files({ hidden = true })
end, {
  desc = "(f)iles in (p)roject based on where you opened Neovim. Will ignore .gitignore files when you have a .git folder",
})
set("n", "<leader>fg", function()
  builtin.live_grep({
    additional_args = { "--glob=!node_modules" },
  })
end, { desc = "(f)ile (g)rep. Search for keywords in your project, based on where you opened Neovim." })
-- set("n", "<leader>fb", builtin.buffers, { desc = "(f)ile (b)uffers" })

set("n", "<leader>fb", function()
  builtin.buffers({
    attach_mappings = function(_, map)
      map("n", "d", require("telescope.actions").delete_buffer)
      return true -- keep all existing mappings
    end,
  })
end, { desc = "(f)ile (b)uffers" })

set("n", "<leader>fh", builtin.help_tags, { desc = "(f)ile (h)elp tags" })
set("n", "<leader>fk", builtin.keymaps, { desc = "(f)ile (k)eymaps" })
set("n", "<leader>gf", function()
  -- NOTE: the _ represents an error
  local ok, _ = pcall(builtin.git_files)
  if not ok then
    vim.notify(
      table.concat({
        "Warning: Not a git directory.",
        "Searching through directory.",
        "Copy .gitignore to .ignore to ignore files & directories",
      }, "\n"),
      vim.log.levels.WARN
    )
    pcall(builtin.find_files, { hidden = true })
  else
    vim.notify("Searched through git directory", vim.log.levels.INFO)
  end
end, { desc = "(g)it (f)iles" })

set("n", "<C-p>", builtin.find_files, { desc = "Find files that are tracked by git." })

autocmd("FileType", {
  pattern = { "TelescopePrompt", "TelescopeResults", "TelescopePreview" },
  group = user_config_group,
  desc = "Hide statusline in Telescope windows",
  callback = function()
    vim.opt_local.statusline = ""
  end,
})

-- ===========================================================================
-- PLUGIN: HARPOON.NVIM
-- ===========================================================================
local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local themes = require("telescope.themes")
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  local opts = themes.get_ivy({
    prompt_title = "Working List",
  })

  require("telescope.pickers")
    .new(opts, {
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

local harpoon = require("harpoon")
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Add to harpoon list", nowait = true })

set("n", "<leader>h<leader>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "View harpoon list", nowait = true })

set("n", "<leader>fl", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

-- vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "harpoon",
  group = user_config_group,
  callback = function(event)
    vim.keymap.set("n", "<leader>d", function()
      harpoon:list():remove()
    end, { buffer = event.buf })
  end,
})

