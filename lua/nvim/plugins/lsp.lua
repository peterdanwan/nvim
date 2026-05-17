-- lua/nvim/plugins/lsp.lua
-- ===========================================================================
-- LSP, LINTING, FORMATTING & COMPLETION
-- ===========================================================================

local builtin = require("telescope.builtin")
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local user_config_group = require("core.augroups").user_config_group
local diagnostic = vim.diagnostic

local diagnostic_signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [diagnostic.severity.INFO] = diagnostic_signs.Info,
      [diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    -- source = "always",
    source = "if_many",
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
  },
})

local function lsp_on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end

  local bufnr = ev.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }

  set("n", "<leader>gd", function()
    -- require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
    builtin.lsp_definitions({ jump_type = "tab_drop" })
  end, opts)

  -- PW: might not need. Try gd itself
  set("n", "<leader>gD", vim.lsp.buf.definition, opts)

  set("n", "<leader>gS", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
  end, opts)

  set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  set("n", "<F2>", vim.lsp.buf.rename, opts)

  set("n", "<leader>D", function()
    diagnostic.open_float({ scope = "line" })
  end, opts)
  set("n", "<leader>d", function()
    diagnostic.open_float({ scope = "cursor" })
  end, opts)
  set("n", "<leader>nd", function()
    diagnostic.jump({ count = 1 })
  end, opts)

  set("n", "<leader>pd", function()
    diagnostic.jump({ count = -1 })
  end, opts)

  set("n", "K", function()
    vim.lsp.buf.hover({
      vim.lsp.buf.hover({ border = "rounded" }),
    })
  end, opts)

  set("n", "<leader>fd", function()
    builtin.lsp_definitions({ jump_type = "tab drop" })
    -- require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end, opts)

  set("n", "<leader>fr", function()
    builtin.lsp_references()
    -- require("fzf-lua").lsp_references()
  end, opts)
  set("n", "<leader>ft", function()
    builtin.lsp_type_definitions({ jump_type = "tab drop" })
    -- require("fzf-lua").lsp_typedefs()
  end, opts)
  set("n", "<leader>fs", function()
    builtin.lsp_document_symbols()
    -- require("fzf-lua").lsp_document_symbols()
  end, opts)
  set("n", "<leader>fw", function()
    builtin.lsp_workspace_symbols()
    -- require("fzf-lua").lsp_workspace_symbols()
  end, opts)
  set("n", "<leader>fi", function()
    builtin.lsp_implementations()
    -- require("fzf-lua").lsp_implementations()
  end, opts)

  if client:supports_method("textDocument/codeAction", bufnr) then
    -- Organizes imports (system libs before file libs)
    set("n", "<leader>oi", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
      vim.defer_fn(function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end, 50)
    end, opts)
  end
end

autocmd("LspAttach", { group = user_config_group, callback = lsp_on_attach })

set("n", "<leader>q", function()
  diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })

set("n", "<leader>dl", diagnostic.open_float, { desc = "Show line diagnostics" })

require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<C-Space>"] = { "show", "hide" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    -- ["<Esc>"] = { "hide", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    menu = { auto_show = true },
    trigger = {
      show_on_trigger_character = false,
    },
  },
  sources = { default = { "lsp", "path", "buffer", "snippets" } },
  snippets = {
    preset = "luasnip",
    -- expand = function(snippet)
    --   require("luasnip").lsp_expand(snippet)
    -- end,
    -- active = function(filter)
    --   return require("luasnip").in_snippet() and require("luasnip").jumpable(filter and filter.direction or 1)
    -- end,
    active = function(filter)
      return require("luasnip").locally_jumpable(filter and filter.direction or 1)
    end,
    jump = function(direction)
      require("luasnip").jump(direction)
    end,
  },

  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { download = true },
  },
})

local lsp = vim.lsp

-- TEST: Diagnostic display config
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    spacing = 5,
    severity = { min = vim.diagnostic.severity.WARN },
  },
  update_in_insert = true,
})

lsp.config["*"] = {
  -- Attaches the completion capabilities to all of the language servers, even if we don't have a language server installed
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- ***************************************************************************
-- NOTE: lsp.config is dealing with the raw, lsp that we install via Mason
-- NOTE: lsp.enable deals with calling the raw lsp with predefined defaults from nvim-lspconfig and it might be named something different
-- Ensure you actually install the language servers via Mason so that once they're installed, you can tell Neovim how you want to configure them and enable them
-- ***************************************************************************

lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})
lsp.config("fish-lsp", {})
lsp.config("pyright", {})
lsp.config("bashls", {})
lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
-- lsp.config("gopls", {})
lsp.config("clangd", {})
lsp.config("json-lsp", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = {
        {
          -- Matches any file named package.json
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
      },
      validate = { enable = true },
    },
  },
})
lsp.config("cssls", {
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})

lsp.config("emmet_language_server", {})
lsp.config("vue_ls", {})
lsp.config("docker_language_server", {})
lsp.config("docker_compose_language_service", {})

-- Useful commands include:
-- :Mason -- to check what language servers / formatters / linters you've installed
-- : -- to check what language servers / formatters / linters you've installed
require("mason").setup({})

do
  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")

  stylua = vim.tbl_deep_extend("force", stylua, {
    formatCommand = stylua.formatCommand:gsub("'${INPUT}'", "${INPUT}"),
    -- efmls-configs definition includes rootMarkers = { "stylua.toml", ".stylua.toml" }.
    -- This tells efm-langserver "only apply stylua in directories that contain one of these files." Since you don't have either, efm just skips it silently.
    -- You need to clear the rootMarkers in the same override
    -- Now, efm applies stylua regardless of the presence of a config file and use its defaults when stylua.toml isn't defined
    rootMarkers = {},
  })

  local flake8 = require("efmls-configs.linters.flake8")
  local black = require("efmls-configs.formatters.black")

  local prettier_d = require("efmls-configs.formatters.prettier_d")
  prettier_d = vim.tbl_deep_extend("force", prettier_d, {
    formatCommand = prettier_d.formatCommand:gsub("'${INPUT}'", "${INPUT}"),
  })
  local eslint_d = require("efmls-configs.linters.eslint_d")
  eslint_d = vim.tbl_deep_extend("force", eslint_d, {
    -- :lua print(vim.inspect(require("efmls-configs.linters.eslint_d")))
    -- Windows specific configuration
    lintCommand = eslint_d.lintCommand:gsub('"${INPUT}"', "${INPUT}"),
  })

  local fixjson = require("efmls-configs.formatters.fixjson")

  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")

  local cpplint = require("efmls-configs.linters.cpplint")
  local clangfmt = require("efmls-configs.formatters.clang_format")

  -- local go_revive = require("efmls-configs.linters.go_revive")
  -- local gofumpt = require("efmls-configs.formatters.gofumpt")

  lsp.config("efm", {
    filetypes = {
      "c",
      "cpp",
      "css",
      -- "go",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "sh",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    init_options = { documentFormatting = true },
    settings = {
      -- We provide (linter, formatter)
      languages = {
        c = { clangfmt, cpplint },
        -- go = { gofumpt, go_revive },
        cpp = { clangfmt, cpplint },
        css = { prettier_d },
        html = { prettier_d },
        javascript = { eslint_d, prettier_d },
        javascriptreact = { eslint_d, prettier_d },
        json = { eslint_d, fixjson },
        jsonc = { eslint_d, fixjson },
        lua = { luacheck, stylua },
        markdown = { prettier_d },
        python = { flake8, black },
        sh = { shellcheck, shfmt },
        typescript = { eslint_d, prettier_d },
        typescriptreact = { eslint_d, prettier_d },
        vue = { eslint_d, prettier_d },
        svelte = { eslint_d, prettier_d },
      },
    },
  })
end

-- These are enabling the default configurations from nvim-lspconfig
lsp.enable({
  "lua_ls",
  "fish_lsp",
  "pyright",
  "bashls",
  "ts_ls",
  -- "gopls",
  "clangd",
  "efm",
  "json-lsp",
  "vue_ls",
  "emmet_language_server",
  "cssls",
})

local function setupLuaSnip()
  local has = vim.fn.has
  local expand = vim.fn.expand

  local function vscode_user_snippets()
    if has("win32") == 1 then
      return expand("$USERPROFILE/AppData/Roaming/Code/User/snippets")
    elseif has("mac") == 1 then
      return expand("$HOME/Library/Application Support/Code/User/snippets")
    else
      return expand("$HOME/.config/Code/User/snippets")
    end
  end

  -- ---------------------------------------------------------------------------
  -- Auto-installing VSCode extension snippet packs
  --
  -- Pass plain extension IDs (e.g. "sdras.vue-vscode-snippets").
  -- On first load Neovim downloads the VSIX from the Marketplace, extracts it
  -- into ~/.vscode/extensions/<id>-nvim/, and hot-loads it into LuaSnip.
  -- On subsequent loads the cached directory is used immediately — no network
  -- access, no delay.
  --
  -- To add a new pack:
  --   1. Find its Unique Identifier on the Marketplace page.
  --   2. Append the ID string to the list passed to ensure_vscode_extensions().
  --   3. Restart Neovim once — it downloads and installs in the background.
  -- ---------------------------------------------------------------------------

  local is_win = has("win32") == 1
  local ext_root = (is_win and expand("$USERPROFILE/.vscode/extensions/") or expand("$HOME/.vscode/extensions/")) .. "/"

  -- Returns the unzip command for the current platform.
  local function unzip_cmd(src, dest)
    if is_win then
      return {
        "powershell",
        "-NoProfile",
        "-NonInteractive",
        "-Command",
        ("Expand-Archive -LiteralPath '%s' -DestinationPath '%s' -Force"):format(src, dest),
      }
    end
    return { "unzip", "-o", src, "-d", dest }
  end

  -- Downloads and installs a single extension, then hot-loads it into LuaSnip.
  local function install_extension(id)
    local publisher, name = id:match("^([^%.]+)%.(.+)$")
    if not publisher then
      vim.notify(("[snippets] Invalid extension ID: %s"):format(id), vim.log.levels.WARN)
      return
    end

    -- VSIXs are downloaded from this predictable URL; "latest" resolves on the server side.
    local url = ("https://marketplace.visualstudio.com/_apis/public/gallery/publishers/%s/vsextensions/%s/latest/vspackage"):format(
      publisher,
      name
    )
    local tmp_vsix = vim.fn.tempname() .. ".vsix"

    -- The directory we extract into.  Named <id>-nvim so it won't collide with
    -- a VSCode-managed install (which uses <id>-<semver>).
    local install_dir = ext_root .. id .. "-nvim"

    vim.notify(("[snippets] Downloading %s…"):format(id), vim.log.levels.INFO)

    vim.system({ "curl", "-fsSL", "-o", tmp_vsix, url }, {}, function(dl)
      if dl.code ~= 0 then
        vim.schedule(function()
          vim.notify(("[snippets] Download failed for %s:\n%s"):format(id, dl.stderr or ""), vim.log.levels.ERROR)
        end)
        os.remove(tmp_vsix)
        return
      end

      vim.fn.mkdir(install_dir, "p")

      vim.system(unzip_cmd(tmp_vsix, install_dir), {}, function(ex)
        os.remove(tmp_vsix)

        if ex.code ~= 0 then
          vim.schedule(function()
            vim.notify(("[snippets] Extraction failed for %s"):format(id), vim.log.levels.ERROR)
          end)
          return
        end

        -- A VSIX zip wraps everything under an "extension/" subfolder.
        -- VSCode itself strips that layer when installing, so we replicate that:
        -- after unzip, load from <install_dir>/extension (where package.json lives).
        local snippet_path = install_dir .. "/extension"

        vim.schedule(function()
          vim.notify(("[snippets] Installed %s"):format(id), vim.log.levels.INFO)
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
        end)
      end)
    end)
  end

  -- Returns already-available snippet paths and kicks off background installs
  -- for anything not yet on disk.
  local function ensure_vscode_extensions(ext_ids)
    local paths = {}

    for _, id in ipairs(ext_ids) do
      -- 1. Did WE install it previously?  (<id>-nvim/extension/ layout)
      local our_dir = ext_root .. id .. "-nvim"
      if vim.fn.isdirectory(our_dir) == 1 then
        table.insert(paths, our_dir .. "/extension")

      -- 2. Did VSCode install it?  (<id>-<semver>/ layout, package.json at root)
      else
        local vscode_hits = vim.fn.glob(ext_root .. id .. "-[0-9]*", false, true)
        if #vscode_hits > 0 then
          vim.list_extend(paths, vscode_hits)

        -- 3. Not found anywhere — download in the background.
        else
          install_extension(id)
        end
      end
    end

    return paths
  end

  -- Sync RELATIVE_FILEPATH env var for any snippet that uses it
  autocmd({ "BufEnter", "BufWinEnter" }, {
    group = user_config_group,
    callback = function()
      vim.env.RELATIVE_FILEPATH = vim.fn.expand("%:~:."):gsub("\\", "/")
    end,
  })

  local loader = require("luasnip.loaders.from_vscode")

  -- 1. friendly-snippets via runtimepath (packadd already put it there)
  loader.lazy_load()

  -- 2. Your own VS Code user snippets
  loader.load({ paths = { vscode_user_snippets() } })

  -- 3. VSCode extension snippet packs — add IDs here as needed.
  --    First run: downloads in the background and hot-loads into the current session.
  --    All subsequent runs: loads instantly from the cached directory.
  local ext_paths = ensure_vscode_extensions({
    "dsznajder.es7-react-js-snippets",
    "andys8.jest-snippets",
    "burkeholland.simple-react-snippets",
    "xabikos.JavaScriptSnippets",
    "woodreamz.es7-react-js-snippets",
    "kleber-swf.unity-code-snippets",
    "sdras.vue-vscode-snippets",
  })
  if #ext_paths > 0 then
    loader.lazy_load({ paths = ext_paths })
  end

  -- Match VS Code select-mode behaviour for placeholders
  set("s", "<BS>", "<C-g>c", { desc = "Delete placeholder, stay in insert mode" })
  set("s", "<Del>", "<C-g>c", { desc = "Delete placeholder, stay in insert mode" })
end

setupLuaSnip()

require("nvim-ts-autotag").setup({})

